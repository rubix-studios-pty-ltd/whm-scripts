# Imunify360 WP Compress

Imunify360 allowlist sync for WP Compress service requests.

This integration allows approved WP Compress service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where WP Compress image optimisation, CDN, media delivery, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wp-compress/install.sh | bash
```

## What This Does

The installer sets up the WP Compress allowlist sync for Imunify360.

The integration keeps approved WP Compress service IP addresses available to the server so image optimisation, CDN, media delivery, and related service requests can complete successfully.

The sync retrieves the WP Compress IP list from the published plain text endpoint and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wp-compress/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)