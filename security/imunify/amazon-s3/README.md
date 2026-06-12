# Imunify360 Amazon S3

Imunify360 allowlist sync for Amazon S3 service requests.

This integration allows approved Amazon S3 service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where S3 object storage, media delivery, backup, plugin, or integration traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/amazon-s3/install.sh | bash
```

## What This Does

The installer sets up the Amazon S3 allowlist sync for Imunify360.

The integration keeps approved Amazon S3 IPv4 and IPv6 ranges available to the server so S3 storage, media, backup, and integration requests can complete successfully.

The sync retrieves AWS IP ranges from the official AWS `ip-ranges.json` endpoint, filters only entries where the service is `S3`, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `jq` installed on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/amazon-s3/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)