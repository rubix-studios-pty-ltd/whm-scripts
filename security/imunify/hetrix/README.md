# Imunify360 HetrixTools

Imunify360 allowlist sync for HetrixTools uptime monitor service requests.

This integration allows approved HetrixTools uptime monitoring IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where HetrixTools monitoring requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/hetrix/install.sh | bash
```

## What This Does

The installer sets up the HetrixTools allowlist sync for Imunify360.

The integration keeps approved HetrixTools uptime monitoring IP addresses available to the server so availability checks and uptime monitoring requests can complete successfully.

The sync retrieves the HetrixTools uptime monitor IP list from the published plain text endpoint and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/hetrix/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)