#!/bin/bash

exec 9>/var/run/pmg-sync.lock
flock -n 9 || exit 0

source /root/.pmg-sync.env

FORCE_IPV4="${FORCE_IPV4:-true}"
CURL_OPTS=(-sS -k --connect-timeout 10)

if [ "$FORCE_IPV4" = true ]; then
    CURL_OPTS=(-4 "${CURL_OPTS[@]}")
fi

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log "ERROR: Required command not found: $1"
        exit 1
    fi
}

require_command curl
require_command jq
require_command dig
require_command whmapi1
require_command flock

check_mx() {
    local domain="$1"
    local mx_hosts
    local mx_ip
    local points_to_allowed=false
    local server_ips_string

    mx_hosts=$(dig +short MX "$domain" 2>/dev/null | awk '{print $NF}' | sed 's/\.$//')

    if [ -z "$mx_hosts" ]; then
        log "WARNING: No MX records found for $domain"
        return 1
    fi

    server_ips_string=$(printf "%s\n" "${SERVER_IPS[@]}")

    for mx in $mx_hosts; do
        if [[ "$mx" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            mx_ip="$mx"
        else
            mx_ip=$(dig +short A "$mx" 2>/dev/null | head -n1)
        fi

        if [ -n "$mx_ip" ] && printf "%s\n" "$server_ips_string" | grep -Fxq "$mx_ip"; then
            points_to_allowed=true
            log "MX record points to our server: $domain -> $mx ($mx_ip)"
            break
        fi
    done

    if [ "$points_to_allowed" = true ]; then
        return 0
    fi

    log "MX verification failed for $domain"
    return 1
}

pmg_get() {
    local endpoint="$1"

    curl "${CURL_OPTS[@]}" \
        -b "PMGAuthCookie=$TICKET" \
        -H "CSRFPreventionToken: $CSRF_TOKEN" \
        -X GET \
        "https://$PMG_IP:8006/api2/json$endpoint"
}

pmg_post_json() {
    local endpoint="$1"
    local payload="$2"

    curl "${CURL_OPTS[@]}" \
        -b "PMGAuthCookie=$TICKET" \
        -H "CSRFPreventionToken: $CSRF_TOKEN" \
        -H "Content-Type: application/json" \
        -X POST \
        -d "$payload" \
        "https://$PMG_IP:8006/api2/json$endpoint"
}

pmg_delete() {
    local endpoint="$1"

    curl "${CURL_OPTS[@]}" \
        -b "PMGAuthCookie=$TICKET" \
        -H "CSRFPreventionToken: $CSRF_TOKEN" \
        -X DELETE \
        "https://$PMG_IP:8006/api2/json$endpoint"
}

log "Getting authentication ticket from PMG..."

AUTH_RESPONSE=$(curl "${CURL_OPTS[@]}" \
    -X POST \
    --data-urlencode "username=$PMG_USER" \
    --data-urlencode "password=$PMG_PASSWORD" \
    "https://$PMG_IP:8006/api2/json/access/ticket")

if ! echo "$AUTH_RESPONSE" | jq -e '.data.ticket' >/dev/null 2>&1; then
    log "ERROR: Authentication failed."
    log "PMG response: $AUTH_RESPONSE"
    exit 1
fi

TICKET=$(echo "$AUTH_RESPONSE" | jq -r '.data.ticket')
CSRF_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.data.CSRFPreventionToken')

if [ -z "$TICKET" ] || [ "$TICKET" = "null" ]; then
    log "ERROR: Failed to get authentication ticket."
    exit 1
fi

if [ -z "$CSRF_TOKEN" ] || [ "$CSRF_TOKEN" = "null" ]; then
    log "ERROR: Failed to get CSRF token."
    exit 1
fi

log "Fetching domains from cPanel..."

DOMAINS_CPANEL_ALL=$(whmapi1 get_domain_info --output=json \
    | jq -r 'tostream | select(.[0][-1]=="domain") | .[1]' \
    | sort -u)

if [ -z "$DOMAINS_CPANEL_ALL" ]; then
    log "No domains found in cPanel."
fi

DOMAINS_TO_SYNC="$DOMAINS_CPANEL_ALL"

log "Fetching relay domains from PMG..."

RESPONSE_DOMAINS_PMG=$(pmg_get "/config/domains")

DOMAINS_PMG=$(echo "$RESPONSE_DOMAINS_PMG" \
    | jq -r '.data[]? | .domain // empty' 2>/dev/null \
    | sort -u)

TRANSPORTS_PMG=""
TRANSPORTS_OUR_SERVER=""

if [ "$SYNC_TRANSPORTS" = true ]; then
    log "Fetching transport entries from PMG..."

    RESPONSE_TRANSPORTS_PMG=$(pmg_get "/config/transport")

    TRANSPORTS_PMG=$(echo "$RESPONSE_TRANSPORTS_PMG" \
        | jq -r '.data[]? | .domain // empty' 2>/dev/null \
        | sort -u)

    TRANSPORTS_OUR_SERVER=$(echo "$RESPONSE_TRANSPORTS_PMG" \
        | jq -r --arg c "$COMMENT" '.data[]? | select((.comment // "") == $c) | .domain // empty' 2>/dev/null \
        | sort -u)

    if [ -z "$TRANSPORTS_PMG" ]; then
        log "No transport entries found in PMG."
    fi

    if [ -n "$TRANSPORTS_OUR_SERVER" ]; then
        log "Transport entries managed by this server comment=\"$COMMENT\": $(echo "$TRANSPORTS_OUR_SERVER" | tr '\n' ' ')"
    else
        log "No transport entries found with this server comment=\"$COMMENT\"."
    fi
fi

if [ "$CHECK_MX" = true ]; then
    log "Verifying MX records for domains before adding to PMG..."

    FILTERED_DOMAINS_CPANEL=""

    while IFS= read -r domain; do
        [ -z "$domain" ] && continue

        if check_mx "$domain"; then
            FILTERED_DOMAINS_CPANEL+="${domain}"$'\n'
            log "Domain $domain passed MX verification."
        else
            log "Skipping add for $domain because MX records do not point to allowed IPs."
        fi
    done <<< "$DOMAINS_CPANEL_ALL"

    DOMAINS_TO_SYNC=$(printf "%s" "$FILTERED_DOMAINS_CPANEL" | sort -u)
fi

log "Syncing relay domains: adding new ones..."

for domain in $DOMAINS_TO_SYNC; do
    if ! printf "%s\n" "$DOMAINS_PMG" | grep -Fxq "$domain"; then
        log "Adding relay domain: $domain"

        ADD_DOMAIN_PAYLOAD=$(jq -nc \
            --arg domain "$domain" \
            --arg comment "$COMMENT" \
            '{domain: $domain, comment: $comment}')

        RESPONSE_ADD=$(pmg_post_json "/config/domains" "$ADD_DOMAIN_PAYLOAD")

        if echo "$RESPONSE_ADD" | jq -e '.data' >/dev/null 2>&1; then
            log "SUCCESS: Relay domain $domain added."
            DOMAINS_PMG=$(printf "%s\n%s\n" "$DOMAINS_PMG" "$domain" | sort -u)
        elif echo "$RESPONSE_ADD" | grep -qi 'already exists'; then
            log "NOTICE: Relay domain $domain already exists."
        else
            log "ERROR adding relay domain $domain: $RESPONSE_ADD"
        fi
    else
        log "Relay domain $domain already exists in PMG. Skipping."
    fi

    if [ "$SYNC_TRANSPORTS" = true ]; then
        if ! printf "%s\n" "$TRANSPORTS_PMG" | grep -Fxq "$domain"; then
            log "Adding transport entry for: $domain"

            ADD_TRANSPORT_PAYLOAD=$(jq -nc \
                --arg domain "$domain" \
                --arg host "$TARGET_HOST" \
                --arg protocol "$PROTOCOL" \
                --arg comment "$COMMENT" \
                --argjson port "$TARGET_PORT" \
                --argjson use_mx "$USE_MX" \
                '{domain: $domain, host: $host, port: $port, protocol: $protocol, use_mx: $use_mx, comment: $comment}')

            RESPONSE_TRANSPORT=$(pmg_post_json "/config/transport" "$ADD_TRANSPORT_PAYLOAD")

            if echo "$RESPONSE_TRANSPORT" | jq -e '.data' >/dev/null 2>&1; then
                log "SUCCESS: Transport entry for $domain added."
                TRANSPORTS_PMG=$(printf "%s\n%s\n" "$TRANSPORTS_PMG" "$domain" | sort -u)
                TRANSPORTS_OUR_SERVER=$(printf "%s\n%s\n" "$TRANSPORTS_OUR_SERVER" "$domain" | sort -u)
            elif echo "$RESPONSE_TRANSPORT" | grep -qi 'already exists'; then
                log "NOTICE: Transport entry for $domain already exists."
            else
                log "ERROR adding transport for $domain: $RESPONSE_TRANSPORT"
            fi
        else
            log "Transport entry for $domain already exists. Skipping."
        fi
    fi
done

log "Syncing relay domains: removing obsolete only for domains with transport comment \"$COMMENT\"..."

if [ "$SYNC_TRANSPORTS" != true ]; then
    log "Skipping relay domain removal. Transport sync is disabled, so ownership cannot be confirmed."
elif [ -z "$TRANSPORTS_OUR_SERVER" ]; then
    log "Skipping relay domain removal. No transports with comment \"$COMMENT\"."
else
    for domain in $DOMAINS_PMG; do
        [ -z "$domain" ] && continue

        if ! printf "%s\n" "$TRANSPORTS_OUR_SERVER" | grep -Fxq "$domain"; then
            log "Relay domain $domain has no transport with this server comment. Skipping."
            continue
        fi

        if ! printf "%s\n" "$DOMAINS_CPANEL_ALL" | grep -Fxq "$domain"; then
            log "Removing relay domain because it is no longer in cPanel: $domain"

            RESPONSE_DELETE=$(pmg_delete "/config/domains/$domain")

            if echo "$RESPONSE_DELETE" | jq -e '.data' >/dev/null 2>&1; then
                log "SUCCESS: Relay domain $domain removed."
            else
                log "ERROR removing relay domain $domain: $RESPONSE_DELETE"
            fi
        elif [ "$CHECK_MX" = true ] && ! check_mx "$domain"; then
            log "WARNING: Relay domain $domain exists in cPanel but MX check failed. Keeping."
        else
            log "Relay domain $domain still exists in cPanel. Keeping."
        fi
    done
fi

if [ "$SYNC_TRANSPORTS" = true ]; then
    log "Syncing transport entries: removing obsolete only for entries with comment \"$COMMENT\"..."

    if [ -z "$TRANSPORTS_OUR_SERVER" ]; then
        log "Skipping transport removal. No transports with comment \"$COMMENT\"."
    else
        for domain in $TRANSPORTS_OUR_SERVER; do
            [ -z "$domain" ] && continue

            if ! printf "%s\n" "$DOMAINS_CPANEL_ALL" | grep -Fxq "$domain"; then
                log "Removing transport entry because it is no longer in cPanel: $domain"

                RESPONSE_DELETE_TRANSPORT=$(pmg_delete "/config/transport/$domain")

                if echo "$RESPONSE_DELETE_TRANSPORT" | jq -e '.data' >/dev/null 2>&1; then
                    log "SUCCESS: Transport entry $domain removed."
                else
                    log "ERROR removing transport entry $domain: $RESPONSE_DELETE_TRANSPORT"
                fi
            elif [ "$CHECK_MX" = true ] && ! check_mx "$domain"; then
                log "WARNING: Transport domain $domain exists in cPanel but MX check failed. Keeping."
            else
                log "Transport entry $domain still needed. Keeping."
            fi
        done
    fi
fi

log "Sync complete."