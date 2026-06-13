# WHM and cPanel Extensions and Scripts

A collection of scripts and integrations for extending, automating and managing cPanel and WHM hosting infrastructure. Built for server administrators and hosting providers who need practical tooling around notifications, service integrations, security operations and infrastructure workflows.

## Scripts

### Contact Providers

WHM iContact provider integrations that allow WHM and cPanel server notifications to be sent through supported external services.

| Integration | Description | Installation |
|:---|:---|:---|
| Ntfy | Send WHM and cPanel server notifications through ntfy. | [View](contact-provider/ntfy/README.md) |

### Security

Imunify360 allowlist sync scripts for monitoring platforms, CDN providers, crawlers, payment services, marketing platforms, and other approved service traffic.

| Integration | Description | Installation |
|:---|:---|:---|
| 360 Monitoring | Allowlist sync for 360 Monitoring server monitoring checks. | [View](security/imunify/360monitoring/README.md) |
| Akamai | Allowlist sync for Akamai CDN service requests. | [View](security/imunify/akamai/README.md) |
| Amazon S3 | Allowlist sync for Amazon S3 storage, media, backup, and integration. | [View](security/imunify/amazon-s3/README.md) |
| Better Stack | Allowlist sync for Better Stack uptime monitoring checks. | [View](security/imunify/betterstack/README.md) |
| BunnyCDN | Allowlist sync for BunnyCDN CDN, cache, pull zone, and edge services. | [View](security/imunify/bunnycdn/README.md) |
| Cloudflare | Allowlist sync for Cloudflare CDN service requests. | [View](security/imunify/cloudflare/README.md) |
| CloudFront | Allowlist sync for Amazon CloudFront global and regional edge services. | [View](security/imunify/cloudfront/README.md) |
| CodeGuard | Allowlist sync for CodeGuard backup, restore, monitoring, and file detection. | [View](security/imunify/codeguard/README.md) |
| Crawlers | Allowlist sync for search engine crawlers and visibility tools. | [View](security/imunify/crawlers/README.md) |
| EWWW | Allowlist sync for EWWW Image Optimizer and ExactDN service requests. | [View](security/imunify/ewww/README.md) |
| Fastly | Allowlist sync for Fastly CDN, edge, and proxy service requests. | [View](security/imunify/fastly/README.md) |
| Gcore | Allowlist sync for Gcore CDN service requests. | [View](security/imunify/gcore/README.md) |
| Google | Allowlist sync for Google load balancer, health check and service ranges. | [View](security/imunify/google-lb/README.md) |
| GTranslate | Allowlist sync for GTranslate multilingual page delivery requests. | [View](security/imunify/gtranslate/README.md) |
| HetrixTools | Allowlist sync for HetrixTools uptime monitoring checks. | [View](security/imunify/hetrix/README.md) |
| KeyCDN | Allowlist sync for KeyCDN Shield CDN and origin pull requests. | [View](security/imunify/keycdn/README.md) |
| ManageWP | Allowlist sync for ManageWP management, backup, update and monitoring. | [View](security/imunify/managedwp/README.md) |
| Patchstack | Allowlist sync for Patchstack security scans and vulnerability monitoring. | [View](security/imunify/patchstack/README.md) |
| Payment Providers | Allowlist sync for payment gateway APIs and webhook delivery. | [View](security/imunify/payment/README.md) |
| Klaviyo | Allowlist sync for Klaviyo mailing automation webhooks and callbacks. | [View](security/imunify/klaviyo/README.md) |
| Jetpack | Allowlist sync for WordPress.com and Jetpack service requests. | [View](security/imunify/jetpack/README.md) |
| Imperva | Allowlist sync for Imperva CDN, WAF, proxy, cache, and edge service. | [View](security/imunify/imperva/README.md) |
| Instatus | Allowlist sync for Instatus uptime monitoring checks. | [View](security/imunify/instatus/README.md) |
| QUIC.cloud | Allowlist sync for QUIC.cloud CDN service requests. | [View](security/imunify/quiccloud/README.md) |
| Rank Math | Allowlist sync for Rank Math API and SEO service requests. | [View](security/imunify/rankmath/README.md) |
| Sucuri | Allowlist sync for Sucuri WAF, CDN, proxy, malware and security services. | [View](security/imunify/sucuri/README.md) |
| UptimeRobot | Allowlist sync for UptimeRobot uptime monitoring checks. | [View](security/imunify/uptimerobot/README.md) |
| Wordfence | Allowlist sync for Wordfence security scans, remote checks, and diagnostics. | [View](security/imunify/wordfence/README.md) |
| WP Compress | Allowlist sync for WP Compress image optimisation, CDN, and media. | [View](security/imunify/wp-compress/README.md) |
| WP Rocket | Allowlist sync for WP Rocket cache, preload and optimisation services. | [View](security/imunify/wp-rocket/README.md) |
| WP Umbrella | Allowlist sync for WP Umbrella monitoring, management and security. | [View](security/imunify/wp-umbrella/README.md) |

### Mail

Mail automation scripts for WHM and cPanel servers, covering gateway integration, relay routing and mail infrastructure management.

| Integration | Description | Installation |
|:---|:---|:---|
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