#!/bin/bash

set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/mail/proxmox"
SCRIPT_URL="$RAW_BASE/service.sh"

ENV_FILE="/root/.pmg-sync.env"
SYNC_SCRIPT="/usr/local/bin/cpanel-pmg-sync.sh"
LOG_FILE="/var/log/cpanel-pmg-sync.log"
CRON_LINE="*/30 * * * * $SYNC_SCRIPT >> $LOG_FILE 2>&1"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: Run this installer as root."
        exit 1
    fi
}

prompt_required() {
    local prompt="$1"
    local value=""

    while [ -z "$value" ]; do
        read -rp "$prompt: " value
        value="$(echo "$value" | xargs)"
        [ -z "$value" ] && echo "This value is required."
    done

    printf "%s" "$value"
}

prompt_default() {
    local prompt="$1"
    local default="$2"
    local value=""

    read -rp "$prompt [$default]: " value
    value="$(echo "$value" | xargs)"

    [ -z "$value" ] && value="$default"

    printf "%s" "$value"
}

prompt_secret() {
    local prompt="$1"
    local value=""

    while [ -z "$value" ]; do
        read -rsp "$prompt: " value
        echo
        value="$(echo "$value" | xargs)"
        [ -z "$value" ] && echo "This value is required."
    done

    printf "%s" "$value"
}

escape_double_quotes() {
    printf "%s" "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

install_dependencies() {
    log "Checking dependencies..."

    if command -v dnf >/dev/null 2>&1; then
        dnf install -y curl jq bind-utils nmap-ncat util-linux
    elif command -v yum >/dev/null 2>&1; then
        yum install -y curl jq bind-utils nmap-ncat util-linux
    elif command -v apt-get >/dev/null 2>&1; then
        apt-get update
        apt-get install -y curl jq dnsutils netcat-openbsd util-linux
    else
        log "ERROR: Unsupported package manager. Install curl, jq, dig, nc and flock manually."
        exit 1
    fi

    if ! command -v whmapi1 >/dev/null 2>&1; then
        log "ERROR: whmapi1 not found. This installer must be run on a WHM/cPanel server."
        exit 1
    fi
}

install_sync_script() {
    log "Downloading sync script from:"
    log "$SCRIPT_URL"

    if [ -f "$SYNC_SCRIPT" ]; then
        local backup="${SYNC_SCRIPT}.bak.$(date '+%Y%m%d-%H%M%S')"
        cp -a "$SYNC_SCRIPT" "$backup"
        log "Existing sync script backed up to $backup"
    fi

    curl -fsSL "$SCRIPT_URL" -o "$SYNC_SCRIPT"

    chown root:root "$SYNC_SCRIPT"
    chmod 700 "$SYNC_SCRIPT"

    log "Sync script installed at $SYNC_SCRIPT"
}

write_env_file() {
    log "Setting up $ENV_FILE"

    if [ -f "$ENV_FILE" ]; then
        local backup="${ENV_FILE}.bak.$(date '+%Y%m%d-%H%M%S')"
        cp -a "$ENV_FILE" "$backup"
        chmod 600 "$backup"
        log "Existing env file backed up to $backup"
    fi

    echo
    echo "PMG API settings"
    PMG_IP="$(prompt_required "PMG IP or hostname")"
    PMG_USER="$(prompt_required "PMG username, for example root@pam or user@pmg")"
    PMG_PASSWORD="$(prompt_secret "PMG password")"
    FORCE_IPV4="$(prompt_default "Force IPv4, true or false" "true")"

    echo
    echo "Transport settings"
    SYNC_TRANSPORTS="$(prompt_default "Sync PMG transport entries, true or false" "true")"
    TARGET_HOST="$(prompt_required "Target host for mail routing, usually this WHM server IP")"
    TARGET_PORT="$(prompt_default "Target SMTP port" "25")"
    PROTOCOL="$(prompt_default "Transport protocol" "smtp")"
    USE_MX="$(prompt_default "Use MX lookup for transport, 0 or 1" "0")"
    COMMENT="$(prompt_default "Ownership comment for PMG transport entries" "Added automatically by cPanel sync script")"

    echo
    echo "MX verification settings"
    CHECK_MX="$(prompt_default "Enable MX verification before adding domains, true or false" "true")"
    SERVER_IPS_RAW="$(prompt_required "Allowed MX IPs, comma or space separated")"

    SERVER_IPS_ARRAY=""
    SERVER_IPS_NORMALISED="$(echo "$SERVER_IPS_RAW" | tr ',' ' ')"

    for ip in $SERVER_IPS_NORMALISED; do
        ip="$(echo "$ip" | xargs)"
        [ -z "$ip" ] && continue
        SERVER_IPS_ARRAY+="\"$(escape_double_quotes "$ip")\" "
    done

    cat > "$ENV_FILE" <<EOF
# Proxmox Mail Gateway
PMG_IP="$(escape_double_quotes "$PMG_IP")"
PMG_USER="$(escape_double_quotes "$PMG_USER")"
PMG_PASSWORD="$(escape_double_quotes "$PMG_PASSWORD")"

FORCE_IPV4=$FORCE_IPV4

# Transport
SYNC_TRANSPORTS=$SYNC_TRANSPORTS
TARGET_HOST="$(escape_double_quotes "$TARGET_HOST")"
TARGET_PORT="$TARGET_PORT"
PROTOCOL="$(escape_double_quotes "$PROTOCOL")"
USE_MX=$USE_MX
COMMENT="$(escape_double_quotes "$COMMENT")"

# MX Verification
CHECK_MX=$CHECK_MX
SERVER_IPS=($SERVER_IPS_ARRAY)
EOF

    chown root:root "$ENV_FILE"
    chmod 600 "$ENV_FILE"

    log "Env file created: $ENV_FILE"
}

setup_log_file() {
    touch "$LOG_FILE"
    chown root:root "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    log "Log file ready: $LOG_FILE"
}

install_cron() {
    log "Installing root cron job..."

    local tmp_cron
    tmp_cron="$(mktemp)"

    crontab -l 2>/dev/null > "$tmp_cron" || true

    if grep -Fq "$SYNC_SCRIPT" "$tmp_cron"; then
        log "Cron job already exists for $SYNC_SCRIPT"
        rm -f "$tmp_cron"
        return
    fi

    {
        cat "$tmp_cron"
        echo "$CRON_LINE"
    } | crontab -

    rm -f "$tmp_cron"

    log "Cron job installed:"
    log "$CRON_LINE"
}

test_connectivity() {
    echo
    read -rp "Test PMG API TCP connectivity now? [y/N]: " do_test
    do_test="${do_test:-N}"

    if [[ ! "$do_test" =~ ^[Yy]$ ]]; then
        return
    fi

    # shellcheck disable=SC1090
    source "$ENV_FILE"

    local nc_cmd=""

    if command -v nc >/dev/null 2>&1; then
        nc_cmd="nc"
    elif command -v ncat >/dev/null 2>&1; then
        nc_cmd="ncat"
    else
        log "ERROR: nc/ncat not found."
        return
    fi

    log "Testing TCP connection to $PMG_IP:8006..."

    if "$nc_cmd" -z -w 5 "$PMG_IP" 8006 >/dev/null 2>&1; then
        log "SUCCESS: TCP connection to $PMG_IP:8006 works."
    else
        log "ERROR: Cannot connect to $PMG_IP:8006 over TCP."
        log "Check WHM outbound TCP 8006 and PMG inbound TCP 8006."
        return
    fi

    local curl_args=(-sS -k --connect-timeout 10)

    if [ "${FORCE_IPV4:-true}" = true ]; then
        curl_args=(-4 "${curl_args[@]}")
    fi

    log "Testing PMG API endpoint..."

    curl "${curl_args[@]}" \
        -w '\nHTTP_CODE=%{http_code}\nREMOTE_IP=%{remote_ip}\n' \
        "https://$PMG_IP:8006/api2/json/version" || true
}

main() {
    require_root
    install_dependencies
    install_sync_script
    write_env_file
    setup_log_file
    install_cron
    test_connectivity

    echo
    log "Install complete."
    log "Sync script: $SYNC_SCRIPT"
    log "Env file: $ENV_FILE"
    log "Log file: $LOG_FILE"
}

main "$@"