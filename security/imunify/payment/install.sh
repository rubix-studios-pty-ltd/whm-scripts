#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/payment"
INSTALL_PATH="/usr/local/sbin/rubix-imunify-payment"
CRON_PATH="/etc/cron.d/rubix-imunify-payment"
LOG_PATH="/var/log/rubix-imunify-payment.log"

echo "Installing Rubix Imunify payment whitelist sync..."

if [[ "$(id -u)" -ne 0 ]]; then
  echo "This installer must be run as root."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y jq
  elif command -v yum >/dev/null 2>&1; then
    yum install -y jq
  else
    echo "jq is required but no supported package manager was found."
    exit 1
  fi
fi

if ! command -v imunify360-agent >/dev/null 2>&1; then
  echo "imunify360-agent was not found. Is Imunify360 installed?"
  exit 1
fi

curl -fsSL "$RAW_BASE/payment.sh" -o "$INSTALL_PATH"

chmod 700 "$INSTALL_PATH"
chown root:root "$INSTALL_PATH"

cat > "$CRON_PATH" <<EOF
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

15 3 * * 1 root $INSTALL_PATH >> $LOG_PATH 2>&1
EOF

chmod 644 "$CRON_PATH"
chown root:root "$CRON_PATH"

echo "Running initial payment whitelist sync..."
"$INSTALL_PATH"

echo "Installed Rubix Imunify payment whitelist sync."
echo "Cron: $CRON_PATH"
echo "Log: $LOG_PATH"
