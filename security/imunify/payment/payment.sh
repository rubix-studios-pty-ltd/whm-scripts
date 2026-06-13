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

fetch_braintree_json() {
  local name="$1"
  local url="$2"

  local tmp_json="$TMP_DIR/${name}.json"
  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  curl -fsSL --connect-timeout 15 --max-time 60 "$url" -o "$tmp_json"

  {
    echo "$COMMENT_PREFIX payment=$name updated=$DATE source=$url"

    jq -r '
      .production.cidrs[]?,
      .production.ips[]?,
      .production.outboundIps[]?,
      .sandbox.cidrs[]?,
      .sandbox.ips[]?,
      .sandbox.outboundIps[]?
    ' "$tmp_json" | sort -u
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

if command -v dig >/dev/null 2>&1; then
  run_source "adyen-webhooks" fetch_dns_a_records \
    "adyen-webhooks" \
    "out.adyen.com"
else
  echo "Skipping adyen-webhooks because dig is not installed."
fi

run_source "airwallex" fetch_static_prefixes \
  "airwallex" \
  "35.240.218.67" \
  "35.185.179.53" \
  "34.87.64.173" \
  "35.220.213.251" \
  "34.92.128.176" \
  "34.91.47.254" \
  "34.91.75.229" \
  "35.230.185.215" \
  "34.86.42.60" \
  "34.177.101.131" \
  "34.143.140.106" \
  "34.158.57.211" \
  "34.124.183.136" \
  "34.126.131.52" \
  "34.21.185.174" \
  "34.142.140.136" \
  "35.236.197.105" \
  "34.11.6.7" \
  "34.145.133.253" \
  "34.182.195.122" \
  "35.186.175.150" \
  "34.85.218.163" \
  "136.107.34.62" \
  "35.186.166.138" \
  "34.21.104.184" \
  "35.240.211.132" \
  "35.187.239.216" \
  "34.87.139.23" \
  "34.92.48.104" \
  "34.92.144.250" \
  "34.92.15.70" \
  "136.110.35.143" \
  "34.142.189.194" \
  "35.197.128.86"

run_source "anz-worldline" fetch_static_prefixes \
  "anz-worldline" \
  "185.139.244.0/24" \
  "185.139.246.0/24" \
  "91.208.214.0/24" \
  "185.8.55.0/24"

run_source "authorize-net" fetch_static_prefixes \
  "authorize-net" \
  "198.241.207.104" \
  "198.241.206.95" \
  "198.241.206.93" \
  "198.241.207.102" \
  "198.241.206.38" \
  "198.241.207.38" \
  "198.241.207.97" \
  "198.241.206.88" \
  "198.241.207.105" \
  "198.241.206.96" \
  "198.241.206.22" \
  "198.241.207.86" \
  "198.241.206.25" \
  "198.241.207.84"

run_source "bluesnap" fetch_static_prefixes \
  "bluesnap" \
  "141.226.140.200" \
  "141.226.141.200" \
  "141.226.142.200" \
  "141.226.143.200" \
  "141.226.140.100" \
  "141.226.141.100" \
  "141.226.142.100" \
  "141.226.143.100"

run_source "braintree" fetch_braintree_json \
  "braintree" \
  "https://assets.braintreegateway.com/json/ips.json"

run_source "checkout-api-live" fetch_plain_list \
  "checkout-api-live" \
  "https://www.checkout.com/docs/files/ip-lists/api-live.txt"

run_source "checkout-api-sandbox" fetch_plain_list \
  "checkout-api-sandbox" \
  "https://www.checkout.com/docs/files/ip-lists/api-sandbox.txt"

run_source "checkout-webhooks-live" fetch_plain_list \
  "checkout-webhooks-live" \
  "https://www.checkout.com/docs/files/ip-lists/webhooks-live.txt"

run_source "checkout-webhooks-sandbox" fetch_plain_list \
  "checkout-webhooks-sandbox" \
  "https://www.checkout.com/docs/files/ip-lists/webhooks-sandbox.txt"


run_source "globalpayments" fetch_static_prefixes \
  "globalpayments" \
  "35.224.174.124" \
  "104.197.227.227" \
  "35.224.109.31" \
  "35.195.157.166" \
  "35.189.207.210" \
  "35.189.44.219" \
  "35.189.5.170" \
  "35.227.1.33" \
  "35.227.1.34" \
  "35.227.131.172" \
  "35.227.131.173" \
  "104.198.79.154" \
  "35.240.103.94" \
  "35.197.163.192" \
  "35.190.154.173" \
  "35.185.206.130" \
  "34.76.69.105" \
  "34.76.200.125" \
  "35.232.128.164" \
  "35.238.234.106" \
  "130.211.235.152" \
  "35.189.227.66" \
  "35.244.81.180" \
  "104.196.113.33" \
  "35.227.131.101" \
  "35.192.194.212" \
  "35.192.194.213" \
  "35.205.1.196" \
  "35.205.1.197" \
  "35.195.21.245" \
  "35.242.192.200" \
  "35.194.59.226" \
  "193.105.253.0/24" \
  "66.233.165.64/27" \
  "77.79.205.0/24" \
  "78.133.228.0/24" \
  "83.238.106.64/26" \
  "193.192.191.0/24" \
  "195.95.188.0/24"

run_source "gocardless-webhooks" fetch_static_prefixes \
  "gocardless-webhooks" \
  "35.204.73.47" \
  "35.204.191.250" \
  "35.204.214.181"


run_source "klarna" fetch_static_prefixes \
  "klarna" \
  "52.17.117.56" \
  "52.17.176.198" \
  "52.0.45.33" \
  "52.0.46.187" \
  "13.211.30.100" \
  "3.104.49.49" \
  "13.54.229.130" \
  "34.242.203.160" \
  "34.242.19.4" \
  "52.45.47.152" \
  "34.235.91.238" \
  "3.24.91.202" \
  "52.62.115.68" \
  "52.63.129.92" \
  "63.33.163.93" \
  "63.34.140.6" \
  "63.34.72.238" \
  "52.18.109.75" \
  "63.32.138.153" \
  "63.32.201.200"

run_source "mollie" fetch_plain_list \
  "mollie" \
  "https://ip-ranges.mollie.com/ips.txt"

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

run_source "payone" fetch_static_prefixes \
  "payone" \
  "185.139.244.0/24" \
  "185.139.246.0/24" \
  "91.208.214.0/24" \
  "185.8.55.0/24"

run_source "paystack" fetch_static_prefixes \
  "paystack" \
  "52.31.139.75" \
  "52.49.173.169" \
  "52.214.14.220"

run_source "przelewy24" fetch_static_prefixes \
  "przelewy24" \
  "5.252.202.255" \
  "5.252.202.254" \
  "20.215.81.124" \
  "193.178.213.0/24" \
  "91.220.177.0/24" \
  "20.215.183.48/28" \
  "134.112.88.8/29"

run_source "skrill" fetch_static_prefixes \
  "skrill" \
  "91.208.28.0/2" \
  "93.191.174.0/24" \
  "193.105.47.0/24" \
  "195.69.173.0/24"

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

run_source "square-webhooks" fetch_static_prefixes \
  "square-webhooks" \
  "54.245.1.154" \
  "34.202.99.168" \
  "54.212.177.79" \
  "107.20.218.8"

run_source "westpac-quickstream" fetch_static_prefixes \
  "westpac-quickstream" \
  "192.170.86.153" \
  "203.39.159.31"

run_source "worldpay" fetch_static_prefixes \
  "worldpay" \
  "195.35.90.0/23"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Payment whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Payment whitelist sync complete."