# Imunify360 CodeGuard

Imunify360 allowlist sync for CodeGuard service requests.

This integration allows approved CodeGuard backup service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where CodeGuard needs reliable access for website backup, restore, monitoring, and file change detection activity without being blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/codeguard/install.sh | bash
```

## What This Does

The installer sets up the CodeGuard allowlist sync for Imunify360.

The integration keeps approved CodeGuard service IP addresses available to the server so backup, restore, scan, and monitoring requests can complete successfully.

The sync writes the CodeGuard IP addresses to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/codeguard/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)