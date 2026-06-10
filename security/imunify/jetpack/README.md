# Imunify360 Jetpack

Imunify360 allowlist sync for WordPress.com and Jetpack service requests.

This integration allows approved WordPress.com and Jetpack service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Jetpack features, WordPress.com callbacks, and related service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/jetpack/install.sh | bash
```

## What This Does

The installer sets up the Jetpack allowlist sync for Imunify360.

The integration is used to keep approved WordPress.com and Jetpack IP ranges available to the server so Jetpack service requests can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/jetpack/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)