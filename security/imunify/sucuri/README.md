# Imunify360 Sucuri

Imunify360 allowlist sync for Sucuri service requests.

This integration allows approved Sucuri IP ranges to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Sucuri WAF, CDN, proxy, malware scanning, and related security service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/sucuri/install.sh | bash
```

## What This Does

The installer sets up the Sucuri allowlist sync for Imunify360.

The integration keeps approved Sucuri IP ranges available to the server so WAF, CDN, proxy, malware scanning, and related security service requests can complete successfully.

The sync writes the Sucuri IP ranges to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/sucuri/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)