# Imunify360 Klaviyo Allowlist Sync

Imunify360 allowlist sync for Klaviyo mailing automation webhooks and callbacks.

This integration allows approved Klaviyo service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Klaviyo webhooks, callbacks, and marketing automation service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/klaviyo/install.sh | bash
```

## What This Does

The installer sets up the Klaviyo allowlist sync for Imunify360.

The integration is used to keep approved Klaviyo IP ranges available to the server so mailing automation webhooks and callbacks can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/klaviyo/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)