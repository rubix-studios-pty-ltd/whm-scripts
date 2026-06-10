# cPanel PMG Sync

cPanel to Proxmox Mail Gateway relay domain and transport synchronisation for WHM servers.

This integration keeps Proxmox Mail Gateway relay domains and transport entries aligned with domains hosted on a WHM and cPanel server. It is intended for environments where PMG is used as the inbound and outbound mail gateway in front of one or more cPanel servers.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/mail/proxmox/install.sh | bash
```

## What This Does

The installer sets up the cPanel to PMG sync service.

It downloads the sync script, creates the environment configuration file, applies secure permissions, prepares the log file and adds a root cron job to run the sync every 30 minutes.

The sync process can manage PMG relay domains and transport entries for domains found on the WHM server. Transport entries are identified using a configurable comment value so entries from other servers or manually managed PMG records are not removed.

## Requirements

- WHM and cPanel server
- Proxmox Mail Gateway
- Root shell access
- PMG API user with permission to manage relay domains and transports
- Outbound TCP access from WHM to PMG port `8006`
- Inbound TCP access on PMG port `8006` from the WHM server
- Outbound DNS lookups from the WHM server
- `curl`, `jq`, `dig`, `flock` and `nc` or `ncat`

## Configuration

The installer creates the following environment file.

```bash
/root/.pmg-sync.env
```

This file stores the PMG API credentials, transport settings, ownership comment and MX verification settings.

Example configuration.

```bash
# Proxmox Mail Gateway
PMG_IP="mx.example.com"
PMG_USER="user@pmg"
PMG_PASSWORD="secure-password"

FORCE_IPV4=true

# Transport
SYNC_TRANSPORTS=true
TARGET_HOST="203.0.113.10"
TARGET_PORT="25"
PROTOCOL="smtp"
USE_MX=0
COMMENT="Added automatically by cPanel sync script"

# MX Verification
CHECK_MX=true
SERVER_IPS=("203.0.113.10")
```

### Configuration Values

| Setting | Purpose |
|---|---|
| `PMG_IP` | PMG hostname, public IP, private IP or Tailscale IP used by the WHM server to reach the PMG API on port `8006`. |
| `PMG_USER` | PMG API username, usually `root@pam` or a dedicated `user@pmg` account. |
| `PMG_PASSWORD` | PMG API password. |
| `FORCE_IPV4` | Forces curl to use IPv4 when connecting to PMG. Use `true` unless IPv6 is required and confirmed working. |
| `SYNC_TRANSPORTS` | Enables PMG transport entry creation and cleanup. This should usually be `true`. |
| `TARGET_HOST` | The destination mail server PMG should deliver mail to, usually the WHM or cPanel server IP. |
| `TARGET_PORT` | SMTP delivery port on the target server, usually `25`. |
| `PROTOCOL` | Transport protocol, usually `smtp`. |
| `USE_MX` | Whether PMG should use MX lookup for transport delivery. Use `0` for direct delivery to `TARGET_HOST`. |
| `COMMENT` | Ownership marker used on PMG transport entries created by this WHM server. |
| `CHECK_MX` | Verifies that domains point to approved MX IPs before adding them to PMG. |
| `SERVER_IPS` | Approved IPs used during MX verification. Add every IP that valid domain MX records may resolve to. |

### Ownership Comment

The `COMMENT` value is important.

The sync script uses the comment on PMG transport entries to identify which domains belong to this WHM server.

```bash
COMMENT="Added automatically by cPanel sync script"
```

In a multi-server PMG setup, use a unique comment per WHM server.

Example.

```bash
COMMENT="Added automatically by cPanel sync script - whm01"
```

Another WHM server should use a different value.

```bash
COMMENT="Added automatically by cPanel sync script - whm02"
```

This prevents one WHM server from removing relay domains or transport entries that belong to another server.

Do not change the `COMMENT` after deployment unless you also update the existing PMG transport entries. If the comment is changed, the script may no longer recognise previously created entries as belonging to that server.

### MX Verification Notes

When `CHECK_MX=true`, the script only adds domains whose MX records resolve to an IP listed in `SERVER_IPS`.

```bash
CHECK_MX=true
SERVER_IPS=("203.0.113.10" "203.0.113.11")
```

If a domain still exists in cPanel but fails MX verification, the script keeps it and logs a warning. This avoids removing active cPanel domains or subdomains that may not have their own MX records.

### File Permissions

The environment file contains PMG credentials and must only be readable by root.

```bash
chmod 600 /root/.pmg-sync.env
chown root:root /root/.pmg-sync.env
```

## Scheduled Task

The installer adds the following root cron job.

```bash
*/30 * * * * /usr/local/bin/cpanel-pmg-sync.sh >> /var/log/cpanel-pmg-sync.log 2>&1
```

The sync script is installed at the following path.

```bash
/usr/local/bin/cpanel-pmg-sync.sh
```

The log file is created at the following path.

```bash
/var/log/cpanel-pmg-sync.log
```

## Permissions

The installer applies the following permissions.

```bash
chmod 700 /usr/local/bin/cpanel-pmg-sync.sh
chmod 600 /root/.pmg-sync.env
chmod 600 /var/log/cpanel-pmg-sync.log
```

## Updating

Re-run the installer to update the sync script from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/mail/proxmox/install.sh | bash
```

Existing configuration files are backed up before being replaced.

## Manual Run

Run the sync manually as `root`.

```bash
/usr/local/bin/cpanel-pmg-sync.sh
```

View the sync log.

```bash
tail -f /var/log/cpanel-pmg-sync.log
```

## Network Notes

The WHM server must be able to connect to PMG on TCP port `8006`.

This is required for PMG API access.

```bash
nc -vz PMG_IP 8006
```

If the connection fails, check outbound TCP rules on the WHM server and inbound TCP rules on the PMG server.

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)