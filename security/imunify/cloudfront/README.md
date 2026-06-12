# Imunify360 CloudFront

Imunify360 allowlist sync for Amazon CloudFront service requests.

This integration allows approved CloudFront edge and regional edge service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where CloudFront CDN, cached asset, media delivery, and edge service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/cloudfront/install.sh | bash
```

## What This Does

The installer sets up the CloudFront allowlist sync for Imunify360.

The integration keeps approved CloudFront global and regional edge IP ranges available to the server so CDN, cache, asset delivery, and edge service requests can complete successfully.

The sync retrieves CloudFront IP ranges from the CloudFront JSON endpoint, extracts both global and regional edge IP lists, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `jq` installed on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/cloudfront/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)