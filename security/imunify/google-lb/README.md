# Imunify360 Google

Imunify360 allowlist sync for Google load balancer, health check, and Google Front End service ranges.

This integration allows approved Google infrastructure requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where Google Load Balancer health checks, Google CDN, Google Front End proxy traffic, or Google-backed service routing should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/google-lb/install.sh | bash
```

## What This Does

The installer sets up the Google allowlist sync for Imunify360.

The integration is used to keep approved Google IP ranges available to the server so Google load balancer checks, CDN routing, and Google Front End service traffic can complete successfully.

It creates and updates Google-specific whitelist files under:

```bash
/etc/imunify360/whitelist/
```

The sync includes:

* Google load balancer health check ranges
* Google IPv6 health check ranges
* Google regional passthrough load balancer health check ranges
* Google Front End external origin IP ranges from `_cloud-eoips.googleusercontent.com`

## Requirements

* WHM and cPanel server
* Imunify360 installed and active
* Root shell access
* Outbound DNS access from the server
* `dig` available on the server

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/google/install.sh | bash
```

## Author

Rubix Studios
https://rubixstudios.com.au
