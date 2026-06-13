#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-spam-experts"
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
    echo "$COMMENT_PREFIX service=$name updated=$DATE source=static"
    printf '%s\n' "$@" | grep -Ev '^\s*$' | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command grep
require_command sort
require_command install
require_command imunify360-agent

run_source "spam-experts" fetch_static_prefixes \
  "spam-experts" \
  "130.117.251.9" \
  "2001:978:2:6::20:10" \
  "185.201.16.0/22" \
  "185.201.16.0/24" \
  "185.201.17.0/24" \
  "185.201.18.0/24" \
  "185.201.19.0/24" \
  "192.69.18.0/24" \
  "208.70.90.0/24" \
  "45.91.121.0/24" \
  "45.93.148.0/24" \
  "45.131.180.0/24" \
  "45.140.132.0/24" \
  "193.41.32.0/24" \
  "185.225.27.0/24" \
  "80.91.219.0/24" \
  "188.190.113.0/24" \
  "45.147.95.0/24" \
  "46.229.240.0/24" \
  "87.236.163.0/24" \
  "188.190.112.0/24" \
  "192.69.19.0/24" \
  "208.70.91.0/24" \
  "185.209.51.0/24" \
  "185.218.226.0/24"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Spam Experts whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Spam Experts whitelist sync complete."