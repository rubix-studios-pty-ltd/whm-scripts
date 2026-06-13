# Imunify360 StatusCake

Imunify360 allowlist sync for StatusCake uptime monitoring service requests.

This integration allows approved StatusCake monitoring IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where StatusCake uptime checks, availability monitoring, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/statuscake/install.sh | bash
```

## What This Does

The installer sets up the StatusCake allowlist sync for Imunify360.

The integration keeps approved StatusCake monitoring IP addresses available to the server so uptime checks, availability monitoring, and related service requests can complete successfully.

The sync retrieves the StatusCake monitoring location list from the published JSON endpoint, extracts IPv4 and IPv6 addresses, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `jq` installed on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/statuscake/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)