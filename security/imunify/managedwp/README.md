# Imunify360 ManageWP

Imunify360 allowlist sync for ManageWP service requests.

This integration allows approved ManageWP service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where ManageWP needs reliable access for WordPress management, backups, updates, uptime monitoring, security checks, and site maintenance activity without being blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/managedwp/install.sh | bash
```

## What This Does

The installer sets up the ManageWP allowlist sync for Imunify360.

The integration keeps approved ManageWP service IP addresses available to the server so WordPress management, backup, update, monitoring, and maintenance requests can complete successfully.

The sync writes the ManageWP IP addresses to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/managedwp/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)