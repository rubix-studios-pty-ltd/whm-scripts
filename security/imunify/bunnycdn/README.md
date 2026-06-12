# Imunify360 BunnyCDN

Imunify360 allowlist sync for BunnyCDN edge server requests.

This integration allows approved BunnyCDN edge server requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where BunnyCDN CDN, cache, pull zone, image optimisation, or edge service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/bunnycdn/install.sh | bash
```

## What This Does

The installer sets up the BunnyCDN allowlist sync for Imunify360.

The integration keeps approved BunnyCDN edge server IP addresses available to the server so CDN, cache, pull zone, and edge service requests can complete successfully.

The sync retrieves BunnyCDN edge server IPs from the BunnyCDN system edge server list and writes them to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/bunnycdn/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)