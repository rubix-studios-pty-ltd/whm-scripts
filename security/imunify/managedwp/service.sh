#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-managedwp"
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

run_source "managedwp" fetch_static_prefixes \
  "managedwp" \
  "34.211.180.66" \
  "54.70.65.107" \
  "34.210.224.7" \
  "52.41.5.108" \
  "52.35.72.129" \
  "54.191.137.17" \
  "35.162.254.253" \
  "52.11.12.231" \
  "52.11.29.70" \
  "52.11.54.161" \
  "52.24.142.159" \
  "52.25.191.255" \
  "52.34.126.117" \
  "52.34.254.47" \
  "52.35.82.99" \
  "52.36.28.80" \
  "52.39.177.152" \
  "52.41.237.12" \
  "52.43.13.71" \
  "52.43.76.224" \
  "52.88.96.110" \
  "52.89.155.51" \
  "54.187.92.57" \
  "54.191.32.65" \
  "54.191.67.23" \
  "54.191.80.119" \
  "54.191.135.209" \
  "54.191.136.176" \
  "54.191.148.85" \
  "54.191.149.8" \
  "52.26.122.21" \
  "52.24.187.29" \
  "52.89.85.107" \
  "54.186.128.167" \
  "54.191.40.136" \
  "52.88.119.122" \
  "52.89.94.121" \
  "52.25.116.116" \
  "52.88.215.225" \
  "54.186.143.184" \
  "52.88.197.180" \
  "52.27.171.126" \
  "34.211.178.241" \
  "52.24.232.158" \
  "52.26.187.210" \
  "52.42.189.119" \
  "54.186.244.128" \
  "54.71.54.102" \
  "34.210.35.214" \
  "34.213.77.188" \
  "34.218.121.176" \
  "52.10.190.191" \
  "52.10.225.96" \
  "52.11.187.168" \
  "52.25.139.76" \
  "52.43.127.200" \
  "54.191.108.9" \
  "54.70.201.228" \
  "44.224.174.169" \
  "52.32.57.81" \
  "44.225.177.160" \
  "34.223.186.249" \
  "44.224.135.238" \
  "44.226.111.14" \
  "44.225.203.104" \
  "44.226.100.122" \
  "44.224.250.144" \
  "44.225.118.211" \
  "54.189.93.69" \
  "44.231.184.112" \
  "44.238.10.27" \
  "54.185.116.30" \
  "44.238.58.95" \
  "52.13.23.154" \
  "54.149.16.35" \
  "44.226.97.20" \
  "54.244.242.144" \
  "44.238.67.135" \
  "44.235.15.76" \
  "54.214.47.164" \
  "34.214.48.135" \
  "54.184.234.227" \
  "44.238.241.95" \
  "52.37.217.170" \
  "34.214.212.42" \
  "54.203.109.179" \
  "35.162.140.124" \
  "54.184.226.94" \
  "3.218.31.131" \
  "54.162.61.185"

imunify360-agent reload-lists

if [ "$FAILURES" -gt 0 ]; then
  echo "ManagedWP whitelist sync complete with $FAILURES failed source(s)."
  exit 1
fi

echo "ManagedWP whitelist sync complete."