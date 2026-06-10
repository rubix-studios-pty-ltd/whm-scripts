# Imunify360 360 Monitoring

Imunify360 allowlist sync for 360 Monitoring server monitoring checks.

This integration allows approved 360 Monitoring service requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where external monitoring checks should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/360monitoring/install.sh | bash
```

## What This Does

The installer sets up the 360 Monitoring allowlist sync for Imunify360.

The integration is used to keep approved 360 Monitoring IP ranges available to the server so monitoring probes can complete successfully.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/360monitoring/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)