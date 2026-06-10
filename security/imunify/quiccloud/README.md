# Imunify360 QUIC.cloud Allowlist Sync

Imunify360 allowlist sync for QUIC.cloud CDN service requests.

This integration allows approved QUIC.cloud service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where QUIC.cloud CDN, cache, optimisation, and WordPress service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/quiccloud/install.sh | bash
```

## What This Does

The installer sets up the QUIC.cloud allowlist sync for Imunify360.

The integration is used to keep approved QUIC.cloud IP ranges available to the server so CDN, cache, optimisation, and WordPress service requests can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/quiccloud/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)