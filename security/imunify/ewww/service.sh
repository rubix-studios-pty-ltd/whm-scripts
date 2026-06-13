#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-ewww"
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

fetch_plain_list() {
  local name="$1"
  local url="$2"

  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  {
    echo "$COMMENT_PREFIX service=$name updated=$DATE source=$url"
    curl -fsSL --connect-timeout 15 --max-time 60 "$url" \
      | sed 's/[[:space:]]*$//' \
      | grep -Ev '^\s*$|^\s*#' \
      | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command curl
require_command grep
require_command sed
require_command sort
require_command install
require_command imunify360-agent

run_source "ewww" fetch_plain_list \
  "ewww" \
  "https://optimize.exactlywww.com/exactdn/servers.php"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "EWWW whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "EWWW whitelist sync complete."