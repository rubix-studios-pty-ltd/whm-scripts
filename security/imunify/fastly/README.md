# Imunify360 Fastly

Imunify360 allowlist sync for Fastly CDN service requests.

This integration allows approved Fastly service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Fastly CDN, edge, and proxy traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/fastly/install.sh | bash
```

## What This Does

The installer sets up the Fastly allowlist sync for Imunify360.

The integration is used to keep approved Fastly IPv4 and IPv6 ranges available to the server so CDN, edge, and proxy service requests can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `jq` installed for parsing the Fastly public IP list

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/fastly/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)