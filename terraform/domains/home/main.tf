// Zone exists so that letsencrypt can use it for DNS-01 challenges, but DNS entries are on local DNS
resource "linode_domain" "this" {
  type        = "master"
  domain      = "home.${var.domain_apex}"
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = var.default_tags
}
