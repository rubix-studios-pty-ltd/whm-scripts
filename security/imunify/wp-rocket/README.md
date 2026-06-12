# Imunify360 WP Rocket

Imunify360 allowlist sync for WP Rocket service requests.

This integration allows approved WP Rocket service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where WP Rocket cache, preload, optimisation, and related service traffic should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wprocket/install.sh | bash
```

## What This Does

The installer sets up the WP Rocket allowlist sync for Imunify360.

The integration keeps approved WP Rocket IPv4 and IPv6 addresses available to the server so cache, preload, optimisation, and related service requests can complete successfully.

The sync retrieves WP Rocket IP ranges from the WP Rocket plain IPv4 and IPv6 lists, normalises the output, and writes the result to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/wprocket/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)