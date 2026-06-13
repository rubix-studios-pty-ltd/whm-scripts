# Imunify360 WP Umbrella

Imunify360 allowlist sync for WP Umbrella service requests.

This integration allows approved WP Umbrella service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where WP Umbrella monitoring, WordPress management, backups, updates, security checks, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wp-umbrella/install.sh | bash
```

## What This Does

The installer sets up the WP Umbrella allowlist sync for Imunify360.

The integration keeps approved WP Umbrella service IP addresses available to the server so monitoring, WordPress management, backup, update, security, and maintenance requests can complete successfully.

The sync retrieves the WP Umbrella IPv4, monitoring, and IPv6 IP lists from the published plain text endpoints and writes the combined result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wp-umbrella/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)