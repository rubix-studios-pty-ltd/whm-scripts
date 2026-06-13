# Imunify360 Site24x7

Imunify360 allowlist sync for Site24x7 monitoring service requests.

This integration allows approved Site24x7 monitoring IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Site24x7 uptime checks, availability monitoring, end-user experience monitoring, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/site24x7/install.sh | bash
```

## What This Does

The installer sets up the Site24x7 allowlist sync for Imunify360.

The integration keeps approved Site24x7 monitoring IP addresses available to the server so uptime checks, availability monitoring, end-user experience monitoring, and related service requests can complete successfully.

The sync resolves the Site24x7 monitoring domain, extracts IPv4 and IPv6 records, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound DNS access from the server
- `dig` installed on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/site24x7/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)