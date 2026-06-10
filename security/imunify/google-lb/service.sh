#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-google-lb"
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

fetch_google_gfe_eoips() {
  local name="$1"
  local tmp_out="$TMP_DIR/${name}.txt"

  {
    echo "$COMMENT_PREFIX service=$name updated=$DATE source=dns-txt:_cloud-eoips.googleusercontent.com"
    dig +short TXT _cloud-eoips.googleusercontent.com \
      | tr ' ' '\n' \
      | tr -d '"' \
      | grep -Eo 'ip4:[^ ]+|ip6:[^ ]+' \
      | cut -d':' -f2- \
      | grep -Ev '^\s*$' \
      | sort -u
  } > "$tmp_out"

  install_list "$name" "$tmp_out"
}

require_command grep
require_command sort
require_command install
require_command imunify360-agent
require_command dig
require_command cut
require_command tr

run_source "google-lb-healthchecks" fetch_static_prefixes \
  "google-lb-healthchecks" \
  "35.191.0.0/16" \
  "130.211.0.0/22" \
  "2600:2d00:1:1::/64" \
  "2600:2d00:1:b029::/64" \
  "2600:1901:8001::/48" \
  "209.85.152.0/22" \
  "209.85.204.0/22"

run_source "google-gfe-eoips" fetch_google_gfe_eoips \
  "google-gfe-eoips"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "Google whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "Google whitelist sync complete."