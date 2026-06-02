#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/etc/imunify360/whitelist"
TMP_DIR="$(mktemp -d)"
COMMENT_PREFIX="# managed-by=rubix-imunify-crawlers"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

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

fetch_json_prefixes() {
  local name="$1"
  local url="$2"
  local output="$BASE_DIR/${name}.txt"
  local tmp_json="$TMP_DIR/${name}.json"
  local tmp_out="$TMP_DIR/${name}.txt"

  echo "Fetching $name from $url"

  curl -fsSL --connect-timeout 15 --max-time 60 "$url" -o "$tmp_json"

  {
    echo "$COMMENT_PREFIX crawler=$name updated=$DATE source=$url"
    jq -r '
      .prefixes[]
      | .ipv4Prefix // .ipv6Prefix // empty
    ' "$tmp_json" | sort -u
  } > "$tmp_out"

  if ! grep -Eq '^[0-9a-fA-F:.]+/[0-9]+$' "$tmp_out"; then
    echo "No valid CIDR ranges found for $name. Keeping existing file."
    return 1
  fi

  install -m 0644 "$tmp_out" "$output"
}

fetch_static_prefixes() {
  local name="$1"
  local output="$BASE_DIR/${name}.txt"
  shift

  {
    echo "$COMMENT_PREFIX crawler=$name updated=$DATE source=static"
    printf '%s\n' "$@" | sort -u
  } > "$output"
}

require_command curl
require_command jq
require_command imunify360-agent

fetch_json_prefixes "applebot" "https://search.developer.apple.com/applebot.json"

fetch_json_prefixes "googlebot" "https://developers.google.com/static/search/apis/ipranges/googlebot.json"
fetch_json_prefixes "google-special-crawlers" "https://developers.google.com/static/search/apis/ipranges/special-crawlers.json"
fetch_json_prefixes "google-user-triggered-fetchers" "https://developers.google.com/static/search/apis/ipranges/user-triggered-fetchers.json"

fetch_json_prefixes "bingbot" "https://www.bing.com/toolbox/bingbot.json"
fetch_json_prefixes "duckduckbot" "https://duckduckgo.com/duckduckbot.json"

fetch_json_prefixes "openai-searchbot" "https://openai.com/searchbot.json"
fetch_json_prefixes "openai-chatgpt-user" "https://openai.com/chatgpt-user.json"

fetch_json_prefixes "perplexitybot" "https://www.perplexity.ai/perplexitybot.json"

fetch_json_prefixes "ahrefsbot" "https://api.ahrefs.com/v3/public/crawler-ip-ranges"

fetch_static_prefixes "semrushbot" \
  "85.208.98.0/24" \
  "85.208.98.128/25"

imunify360-agent reload-lists

echo "Crawler whitelist sync complete."
