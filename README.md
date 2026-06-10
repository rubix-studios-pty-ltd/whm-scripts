# WHM and cPanel Extensions and Scripts

A collection of scripts and integrations for extending, automating and managing cPanel and WHM hosting infrastructure. Built for server administrators and hosting providers who need practical tooling around notifications, service integrations, security operations and infrastructure workflows.

## Scripts

### Contact Providers

WHM iContact provider integrations that allow WHM and cPanel server notifications to be sent through supported external services.

| Integration | Description | Installation |
|---|---|---|
| Ntfy | Send WHM and cPanel server notifications through ntfy. | [View](contact-provider/ntfy/README.md) |

### Security

Imunify360 allowlist sync scripts for monitoring platforms, CDN providers, crawlers, payment services, marketing platforms, and other approved service traffic.

| Integration | Description | Installation |
|---|---|---|
| 360 Monitoring | Allowlist sync for 360 Monitoring server monitoring checks. | [View](security/imunify/360monitoring/README.md) |
| Akamai | Allowlist sync for Akamai CDN service requests. | [View](security/imunify/akamai/README.md) |
| Better Stack | Allowlist sync for Better Stack uptime monitoring checks. | [View](security/imunify/betterstack/README.md) |
| Cloudflare | Allowlist sync for Cloudflare CDN service requests. | [View](security/imunify/cloudflare/README.md) |
| Crawlers | Allowlist sync for search engine crawlers and visibility tools. | [View](security/imunify/crawlers/README.md) |
| Fastly | Allowlist sync for Fastly CDN, edge, and proxy service requests. | [View](security/imunify/fastly/README.md) |
| Google | Allowlist sync for Google load balancer, health check and service ranges. | [View](security/imunify/google-lb/README.md) |
| Payment Providers | Allowlist sync for payment gateway APIs and webhook delivery. | [View](security/imunify/payment/README.md) |
| Klaviyo | Allowlist sync for Klaviyo mailing automation webhooks and callbacks. | [View](security/imunify/klaviyo/README.md) |
| Jetpack | Allowlist sync for WordPress.com and Jetpack service requests. | [View](security/imunify/jetpack/README.md) |
| Instatus | Allowlist sync for Instatus uptime monitoring checks. | [View](security/imunify/instatus/README.md) |
| QUIC.cloud | Allowlist sync for QUIC.cloud CDN service requests. | [View](security/imunify/quiccloud/README.md) |
| Rank Math | Allowlist sync for Rank Math API and SEO service requests. | [View](security/imunify/rankmath/README.md) |
| UptimeRobot | Allowlist sync for UptimeRobot uptime monitoring checks. | [View](security/imunify/uptimerobot/README.md) |

### Mail

Mail automation scripts for WHM and cPanel servers, covering gateway integration, relay routing and mail infrastructure management.

| Integration | Description | Installation |
|---|---|---|
| PMG | Sync cPanel domains with Proxmox Mail Gateway relay domains and transport. | [View](mail/proxmox/README.md) |

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

For support or inquiries:

- LinkedIn: [rubixvi](https://www.linkedin.com/in/rubixvi/)
- Website: [Rubix Studios](https://rubixstudios.com.au)

## Author

Rubix Studios  
[https://rubixstudios.com.au](https://rubixstudios.com.au)