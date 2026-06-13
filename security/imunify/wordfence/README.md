# Imunify360 Wordfence

Imunify360 allowlist sync for Wordfence service requests.

This integration allows approved Wordfence service IP addresses to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Wordfence security scans, remote checks, diagnostics, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wordfence/install.sh | bash
```

## What This Does

The installer sets up the Wordfence allowlist sync for Imunify360.

The integration keeps approved Wordfence service IP addresses available to the server so security scans, remote checks, diagnostics, and related service requests can complete successfully.

The sync writes the Wordfence IP addresses to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wordfence/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)