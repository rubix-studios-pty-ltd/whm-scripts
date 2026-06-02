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

fetch_json_prefixes "googlebot" "https://developers.google.com/static/crawling/ipranges/common-crawlers.json"
fetch_json_prefixes "google-special-crawlers" "https://developers.google.com/static/crawling/ipranges/special-crawlers.json"
fetch_json_prefixes "google-user-triggered-fetchers" "https://developers.google.com/static/crawling/ipranges/user-triggered-agents.json"

fetch_json_prefixes "bingbot" "https://www.bing.com/toolbox/bingbot.json"
fetch_json_prefixes "duckduckbot" "https://duckduckgo.com/duckduckbot.json"

fetch_json_prefixes "openai-searchbot" "https://openai.com/searchbot.json"
fetch_json_prefixes "openai-chatgpt-user" "https://openai.com/chatgpt-user.json"

fetch_json_prefixes "perplexitybot" "https://www.perplexity.ai/perplexitybot.json"

fetch_json_prefixes "ahrefsbot" "https://api.ahrefs.com/v3/public/crawler-ip-ranges"

fetch_static_prefixes "semrushbot" \
  "85.208.98.0/24" \
  "85.208.98.128/25"

fetch_static_prefixes "serankingbot" \
  "5.9.48.208" \
  "46.4.23.25" \
  "46.4.81.149" \
  "136.243.103.47" \
  "136.243.147.42" \
  "138.201.137.152" \
  "142.132.128.37" \
  "142.132.195.214" \
  "144.76.14.242" \
  "144.76.15.151" \
  "144.76.69.81" \
  "144.76.159.253" \
  "144.76.164.62" \
  "144.76.237.123" \
  "162.55.94.175" \
  "162.55.94.176" \
  "162.55.244.19" \
  "168.119.139.232" \
  "168.119.64.236" \
  "176.9.74.49"

imunify360-agent reload-lists

echo "Crawler whitelist sync complete."
