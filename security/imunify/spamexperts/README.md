# Imunify360 Spam Experts

Imunify360 allowlist sync for Spam Experts SMTP delivery and service requests.

This integration allows approved Spam Experts IP addresses and delivery ranges to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Spam Experts inbound delivery, connector traffic, web interface access, telnet, or LDAP sync requests should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/spamexperts/install.sh | bash
```

## What This Does

The installer sets up the Spam Experts allowlist sync for Imunify360.

The integration keeps approved Spam Experts service IPs and SMTP delivery ranges available to the server so mail delivery, connector traffic, web interface access, telnet, and LDAP sync requests can complete successfully.

The sync writes the approved Spam Experts IP addresses and CIDR ranges to a managed Imunify360 whitelist file.

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/spamexperts/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)