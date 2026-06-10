# Imunify360 Crawlers

Imunify360 allowlist sync for approved search engine crawlers, non-training AI crawlers, and visibility tools.

This integration allows approved crawler requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where verified search, indexing, user-triggered fetchers, and SEO visibility tools should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/crawlers/install.sh | bash
```

## What This Does

The installer sets up the crawler allowlist sync for Imunify360.

The integration is used to keep approved crawler IP ranges available to the server so legitimate crawling, indexing, preview, search, and SEO tooling requests can complete successfully.

Included crawler integrations:

- Applebot
- Googlebot common crawlers
- Google special crawlers
- Google user-triggered fetchers
- Bingbot
- DuckDuckBot
- OpenAI SearchBot
- OpenAI ChatGPT user fetcher
- PerplexityBot
- AhrefsBot
- SemrushBot
- SE Ranking Bot

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/crawlers/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)