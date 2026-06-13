# Imunify360 KeyCDN

Imunify360 allowlist sync for KeyCDN Shield service requests.

This integration allows approved KeyCDN Shield IP ranges to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where KeyCDN Shield, CDN origin pull, cached asset, media delivery, and edge service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/keycdn/install.sh | bash
```

## What This Does

The installer sets up the KeyCDN allowlist sync for Imunify360.

The integration keeps approved KeyCDN Shield IP ranges available to the server so CDN, cache, asset delivery, and origin pull requests can complete successfully.

The sync retrieves the KeyCDN Shield prefix list from the published JSON endpoint, extracts the approved prefixes, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `jq` installed on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/keycdn/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)