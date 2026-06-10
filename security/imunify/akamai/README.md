# Imunify360 Akamai Allowlist Sync

Imunify360 allowlist sync for Akamai CDN service requests.

This integration allows approved Akamai service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Akamai CDN traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/akamai/install.sh | bash
```

## What This Does

The installer sets up the Akamai allowlist sync for Imunify360.

The integration is used to keep approved Akamai IP ranges available to the server so CDN service requests can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/akamai/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)