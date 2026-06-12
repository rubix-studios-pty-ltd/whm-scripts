#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-bunnycdn"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
FAILURES=0
UPDATED=0

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

  grep -Ev '^[[:space:]]*($|#)' "$file" | grep -Eq \
    '^(([0-9]{1,3}\.){3}[0-9]{1,3})(/[0-9]{1,2})?$|^([0-9A-Fa-f]{1,4}:){2,}[0-9A-Fa-f:]{1,39}(/[0-9]{1,3})?$'
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
  UPDATED=1

  echo "Installed $output"
}

run_source() {
  local name="$1"
  shift

  if ! "$@"; then
    echo "Failed to update $name."
    FAILURES=$((FAILURES + 1))
  fi
}

fetch_ip_token_list() {
  local name="$1"
  local url="$2"
  local raw="$TMP_DIR/${name}.raw"
  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  if ! curl -fsSL --connect-timeout 15 --max-time 60 "$url" -o "$raw"; then
    echo "Failed to fetch $url"
    return 1
  fi

  {
    echo "$COMMENT_PREFIX service=$name updated=$DATE source=$url"

    (
      grep -aoE \
        '(([0-9]{1,3}\.){3}[0-9]{1,3})(/[0-9]{1,2})?|([0-9A-Fa-f]{1,4}:){2,}[0-9A-Fa-f:]{1,39}(/[0-9]{1,3})?' \
        "$raw" || true
    ) | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command curl
require_command grep
require_command sort
require_command install
require_command imunify360-agent

run_source "bunnycdn" fetch_ip_token_list \
  "bunnycdn" \
  "https://bunnycdn.com/api/system/edgeserverlist"

run_source "bunnycdn-ipv6" fetch_ip_token_list \
  "bunnycdn-ipv6" \
  "https://bunnycdn.com/api/system/edgeserverlist/IPv6"

if [ "$UPDATED" -eq 1 ]; then
  imunify360-agent reload-lists
else
  echo "No whitelist files were updated. Skipping Imunify reload."
fi

if [ "$FAILURES" -gt 0 ]; then
  echo "BunnyCDN whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "BunnyCDN whitelist sync complete."