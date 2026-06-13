#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-site24x7"
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

fetch_dns_records() {
  local name="$1"
  local host="$2"

  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Resolving $name from $host"

  {
    echo "$COMMENT_PREFIX service=$name updated=$DATE source=dns:$host"

    dig +short A "$host" \
      | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$'

    dig +short AAAA "$host" \
      | grep -E '^[0-9A-Fa-f:]+$'
  } | sort -u > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command dig
require_command grep
require_command sort
require_command install
require_command imunify360-agent

run_source "site24x7" fetch_dns_records \
  "site24x7" \
  "site24x7.enduserexp.com"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Site24x7 whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Site24x7 whitelist sync complete."