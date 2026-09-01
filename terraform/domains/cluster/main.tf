resource "linode_domain" "this" {
  type        = "master"
  domain      = "cluster.${var.domain_apex}"
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = var.default_tags
}
