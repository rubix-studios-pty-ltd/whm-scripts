# WHM ntfy Contact Provider

WHM iContact provider integration for sending cPanel and WHM server notifications through [ntfy](https://ntfy.sh).

This script installs a custom WHM contact provider that allows server alerts to be delivered to an ntfy topic. It is designed for WHM and cPanel environments where server notifications need to be sent to a push notification channel instead of relying only on email.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/contact-provider/ntfy/install.sh | bash
```

## What This Installs

The installer adds the ntfy contact provider and schema files into the WHM iContact provider path.

Provider file:

```bash
/var/cpanel/perl/Cpanel/iContact/Provider/Ntfy.pm
```

Schema file:

```bash
/var/cpanel/perl/Cpanel/iContact/Provider/Schema/Ntfy.pm
```

After installation, the provider can be configured from WHM notification settings.

## Configuration

After installation, configure the provider in WHM.

1. Log in to WHM as `root`.
2. Open **Server Contacts > Contact Manager**.
3. Enable the ntfy contact provider.
4. Enter the ntfy topic or endpoint details required by the provider.
5. Send a test notification to confirm delivery.

## ntfy Topic

You can use a public ntfy topic or a self-hosted ntfy server.

Example public topic format:

```text
https://ntfy.sh/example-topic
```

Example self-hosted topic format:

```text
https://ntfy.example.com/example-topic
```

Use a private, hard-to-guess topic name if using the public ntfy service.

## Verification

After installing the provider, confirm both files exist:

```bash
ls -lah /var/cpanel/perl/Cpanel/iContact/Provider/Ntfy.pm
ls -lah /var/cpanel/perl/Cpanel/iContact/Provider/Schema/Ntfy.pm
```

You can also confirm the provider files contain the expected ntfy classes:

```bash
grep -i "ntfy" /var/cpanel/perl/Cpanel/iContact/Provider/Ntfy.pm
grep -i "ntfy" /var/cpanel/perl/Cpanel/iContact/Provider/Schema/Ntfy.pm
```

## Updating

Re-run the installer to replace the installed provider with the latest version from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/contact-provider/ntfy/install.sh | bash
```

## Related Guide

[Push alerts for WHM using ntfy](https://rubixstudios.com.au/insights/push-alerts-for-whm-using-ntfy)

## Notes

This integration is intended for WHM and cPanel servers.

Review the installed provider and test notification delivery before relying on it for production alerting.

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)