resource "linode_domain" "this" {
  type        = "master"
  domain      = "phpdeployment.org"
  soa_email   = var.soa_email
  refresh_sec = 0
  retry_sec   = 0
  ttl_sec     = 0
  tags        = ["managed_by:terraform"]
}

resource "linode_domain_record" "a" {
  domain_id   = linode_domain.this.id
  record_type = "A"
  target      = var.ipv4_address
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

resource "linode_domain_record" "aaaa" {
  domain_id   = linode_domain.this.id
  record_type = "AAAA"
  target      = var.ipv6_address
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

resource "linode_domain_record" "cname" {
  domain_id   = linode_domain.this.id
  name        = "www"
  record_type = "CNAME"
  target      = linode_domain.this.domain
  priority    = 10
  port        = 80 // FIXME: Why
  ttl_sec     = 0
  weight      = 5
}



// FIXME: Move www to cnames