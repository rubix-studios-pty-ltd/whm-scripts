# Imunify360 EWWW

Imunify360 allowlist sync for EWWW service requests.

This integration allows approved EWWW service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where EWWW Image Optimizer should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/ewww/install.sh | bash
```

## What This Does

The installer sets up the EWWW allowlist sync for Imunify360.

The integration keeps approved EWWW service IP addresses available to the server so image optimisation, CDN, media delivery, and ExactDN service requests can complete successfully.

The sync retrieves the EWWW server list from the published endpoint and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/ewww/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)