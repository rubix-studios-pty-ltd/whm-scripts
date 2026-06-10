#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-klaviyo"
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

run_source "klaviyo" fetch_static_prefixes \
  "klaviyo" \
  "207.211.192.0/24" \
  "207.211.193.0/24" \
  "207.211.194.0/24" \
  "207.211.195.0/24" \
  "207.211.196.0/24" \
  "207.211.197.0/24" \
  "207.211.198.0/24" \
  "207.211.199.0/24" \
  "207.211.200.0/24" \
  "207.211.201.0/24" \
  "207.211.202.0/24" \
  "207.211.203.0/24" \
  "207.211.204.0/24" \
  "207.211.205.0/24" \
  "207.211.206.0/24" \
  "207.211.207.0/24"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Klaviyo whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Klaviyo whitelist sync complete."
