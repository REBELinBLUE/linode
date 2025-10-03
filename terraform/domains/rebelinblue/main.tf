resource "linode_domain" "this" {
  type        = "master"
  domain      = var.domain_apex
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = var.default_tags
}

resource "linode_domain_record" "a" {
  domain_id   = linode_domain.this.id
  name        = ""
  record_type = "A"
  target      = var.ipv4_address
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

resource "linode_domain_record" "aaaa" {
  domain_id   = linode_domain.this.id
  name        = ""
  record_type = "AAAA"
  target      = var.ipv6_address
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

resource "linode_domain_record" "verification" {
  for_each = {
    "pwned" = {
      "name"   = ""
      "target" = "have-i-been-pwned-verification=9bf13a9645b5484bef3bbd410b3435c2"
    }
  }

  domain_id   = linode_domain.this.id
  name        = each.value.name
  record_type = "TXT"
  target      = each.value.target
  port        = try(each.value.port, null)
  priority    = try(each.value.priority, 0)
  ttl_sec     = 0
  weight      = try(each.value.weight, 0)
}

resource "linode_domain_record" "cname" {
  for_each = toset([
    "dropshare",
    //"games",
    "www"
  ])

  domain_id   = linode_domain.this.id
  name        = each.value
  record_type = "CNAME"
  target      = linode_domain.this.domain
  priority    = 10
  port        = 80 // FIXME: Why
  ttl_sec     = 0
  weight      = 5
}
