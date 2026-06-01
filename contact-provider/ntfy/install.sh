#!/usr/bin/env bash
set -e

BASE="/var/cpanel/perl/Cpanel/iContact/Provider"
SCHEMA="$BASE/Schema"
RUBIX_URL="https://raw.githubusercontent.com/rubix-studios-pty-ltd/rubix-notify/main/contact-provider/ntfy"

echo "Installing ntfy iContact provider..."

mkdir -p "$BASE" "$SCHEMA"

curl -fsSL "$RUBIX_URL/Provider/Ntfy.pm" -o "$BASE/Ntfy.pm"
curl -fsSL "$RUBIX_URL/Schema/Ntfy.pm" -o "$SCHEMA/Ntfy.pm"

chmod 644 "$BASE/Ntfy.pm" "$SCHEMA/Ntfy.pm"
chown root:root "$BASE/Ntfy.pm" "$SCHEMA/Ntfy.pm"

echo "Installed ntfy provider into WHM iContact"
echo "Configure ntfy in WHM: Server Contacts > Contact Manager"
