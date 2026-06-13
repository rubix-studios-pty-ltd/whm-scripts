# Imunify360 Sendcloud

Imunify360 allowlist sync for Sendcloud service requests.

This integration allows approved Sendcloud service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Sendcloud shipping, webhook, API, and integration traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/sendcloud/install.sh | bash
```

## What This Does

The installer sets up the Sendcloud allowlist sync for Imunify360.

The integration keeps approved Sendcloud public IP addresses available to the server so shipping, webhook, API, and related integration requests can complete successfully.

The sync retrieves the Sendcloud public IP list, normalises the output, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/sendcloud/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)