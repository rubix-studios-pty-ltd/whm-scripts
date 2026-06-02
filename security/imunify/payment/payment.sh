#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-payment"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
FAILURES=0

mkdir -p "$BASE_DIR"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

is_valid_list() {
  local file="$1"

  grep -Ev '^\s*$|^\s*#' "$file" | grep -Eq \
    '^(([0-9]{1,3}\.){3}[0-9]{1,3})(/[0-9]{1,2})?$|^[0-9a-fA-F:]+(/[0-9]{1,3})?$'
}

install_list() {
  local name="$1"
  local tmp_out="$2"
  local output="$BASE_DIR/${name}.txt"

  if ! is_valid_list "$tmp_out"; then
    echo "No valid IP addresses or CIDR ranges found for $name. Keeping existing file."
    return 1
  fi

  install -m 0644 "$tmp_out" "$output"
}

run_source() {
  local name="$1"
  shift

  if ! "$@"; then
    echo "Failed to update $name."
    FAILURES=$((FAILURES + 1))
  fi
}

fetch_static_prefixes() {
  local name="$1"
  shift

  local tmp_out="$TMP_DIR/${name}.txt"

  {
    echo "$COMMENT_PREFIX payment=$name updated=$DATE source=static"
    printf '%s\n' "$@" | grep -Ev '^\s*$' | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

fetch_json_array() {
  local name="$1"
  local url="$2"
  local key="$3"

  local tmp_json="$TMP_DIR/${name}.json"
  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  curl -fsSL --connect-timeout 15 --max-time 60 "$url" -o "$tmp_json"

  {
    echo "$COMMENT_PREFIX payment=$name updated=$DATE source=$url"
    jq -r --arg key "$key" '.[$key][]? // empty' "$tmp_json" | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

fetch_plain_list() {
  local name="$1"
  local url="$2"

  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  {
    echo "$COMMENT_PREFIX payment=$name updated=$DATE source=$url"
    curl -fsSL --connect-timeout 15 --max-time 60 "$url" \
      | sed 's/[[:space:]]*$//' \
      | grep -Ev '^\s*$|^\s*#' \
      | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

fetch_dns_a_records() {
  local name="$1"
  local host="$2"

  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Resolving $name from $host"

  {
    echo "$COMMENT_PREFIX payment=$name updated=$DATE source=dns:$host"
    dig +short A "$host" | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command curl
require_command jq
require_command grep
require_command sort
require_command install
require_command imunify360-agent

run_source "stripe-api" fetch_json_array \
  "stripe-api" \
  "https://stripe.com/files/ips/ips_api.json" \
  "API"

run_source "stripe-armada-gator" fetch_json_array \
  "stripe-armada-gator" \
  "https://stripe.com/files/ips/ips_armada_gator.json" \
  "ARMADA_GATOR"

run_source "stripe-webhooks" fetch_json_array \
  "stripe-webhooks" \
  "https://stripe.com/files/ips/ips_webhooks.json" \
  "WEBHOOKS"

run_source "paypal" fetch_static_prefixes \
  "paypal" \
  "64.4.240.0/21" \
  "64.4.248.0/22" \
  "66.211.168.0/22" \
  "91.243.72.0/23" \
  "173.0.80.0/20" \
  "185.177.52.0/22" \
  "192.160.215.0/24" \
  "198.54.216.0/23"

run_source "westpac-quickstream" fetch_static_prefixes \
  "westpac-quickstream" \
  "192.170.86.153" \
  "203.39.159.31"

run_source "anz-worldline" fetch_static_prefixes \
  "anz-worldline" \
  "185.139.244.0/24" \
  "185.139.246.0/24" \
  "91.208.214.0/24" \
  "185.8.55.0/24"

run_source "square-webhooks" fetch_static_prefixes \
  "square-webhooks" \
  "54.245.1.154" \
  "34.202.99.168" \
  "54.212.177.79" \
  "107.20.218.8"

run_source "checkout-webhooks-live" fetch_plain_list \
  "checkout-webhooks-live" \
  "https://checkout.com/docs/public/files/ip-lists/webhooks-live.txt"

run_source "checkout-webhooks-sandbox" fetch_plain_list \
  "checkout-webhooks-sandbox" \
  "https://checkout.com/docs/public/files/ip-lists/webhooks-sandbox.txt"

if command -v dig >/dev/null 2>&1; then
  run_source "adyen-webhooks" fetch_dns_a_records \
    "adyen-webhooks" \
    "out.adyen.com"
else
  echo "Skipping adyen-webhooks because dig is not installed."
fi

run_source "gocardless-webhooks" fetch_static_prefixes \
  "gocardless-webhooks" \
  "35.204.73.47" \
  "35.204.191.250" \
  "35.204.214.181"
  
imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Payment whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Payment whitelist sync complete."