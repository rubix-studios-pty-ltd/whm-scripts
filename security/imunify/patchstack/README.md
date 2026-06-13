# Imunify360 Patchstack

Imunify360 allowlist sync for Patchstack service requests.

This integration allows approved Patchstack service IP ranges to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Patchstack security scans, vulnerability monitoring, remote checks, and related service requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/patchstack/install.sh | bash
```

## What This Does

The installer sets up the Patchstack allowlist sync for Imunify360.

The integration keeps approved Patchstack service IP ranges available to the server so security scans, vulnerability monitoring, remote checks, and related service requests can complete successfully.

The sync retrieves the Patchstack IPv4 and IPv6 IP lists from the published plain text endpoints and writes the combined result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/patchstack/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)