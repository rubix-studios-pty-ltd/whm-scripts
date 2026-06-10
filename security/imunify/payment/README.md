# Imunify360 Payment Provider Allowlist Sync

Imunify360 allowlist sync for payment gateway APIs and webhook delivery.

This integration allows approved payment provider requests to reach a WHM and cPanel server protected by Imunify360. It is intended for environments where payment APIs, webhook callbacks, checkout services, and gateway notifications should not be blocked or rate-limited by WAF, firewall, or reputation controls.

## Install

Run the installer as `root` on the WHM server.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/payment/install.sh | bash
```

## What This Does

The installer sets up the payment provider allowlist sync for Imunify360.

The integration is used to keep approved payment provider IP ranges available to the server so payment API requests, webhook delivery, and checkout callbacks can complete successfully.

Included payment integrations:

- Stripe API
- Stripe Armada Gator
- Stripe Webhooks
- PayPal
- Westpac QuickStream
- ANZ Worldline
- Square Webhooks
- Checkout.com API Live
- Checkout.com Webhooks Live
- Checkout.com API Sandbox
- Checkout.com Webhooks Sandbox
- Adyen Webhooks
- GoCardless Webhooks
- Authorize.Net
- Global Payments
- Klarna
- Mollie
- PAYONE
- Paystack
- Worldpay
- Airwallex

## Requirements

- WHM and cPanel server
- Imunify360 installed and active
- Root shell access
- Outbound HTTPS access from the server
- `dig` installed for Adyen webhook DNS lookups

## Updating

Re-run the installer to update the integration from this repository.

```bash
curl -fsSL https://raw.githubusercontent.com/rubix-studios-pty-ltd/whm-scripts/main/security/imunify/payment/install.sh | bash
```

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)