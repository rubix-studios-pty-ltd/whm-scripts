# Imunify360 Better Stack Allowlist Sync

Imunify360 allowlist sync for Better Stack uptime monitoring checks.

This integration allows approved Better Stack monitoring requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where external uptime checks should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/betterstack/install.sh | bash
```

## What This Does

The installer sets up the Better Stack allowlist sync for Imunify360.

The integration is used to keep approved Better Stack IP ranges available to the server so uptime monitoring checks can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/betterstack/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)