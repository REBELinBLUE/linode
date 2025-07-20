resource "linode_domain" "this" {
  type        = "master"
  domain      = "home.${var.domain_apex}"
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = var.default_tags
}

# resource "linode_domain_record" "rpi" {
#   for_each = toset([
#     "plex", "tautulli",
#     "sonarr", "jackett", "transmission",
#     "homeassistant"
#   ])

#   domain_id   = linode_domain.this.id
#   name        = each.value
#   record_type = "A"
#   target      = "192.168.3.134"
#   priority    = 0
#   ttl_sec     = 0
#   weight      = 0
# }

# resource "linode_domain_record" "controller" {
#   domain_id   = linode_domain.this.id
#   name        = "controller"
#   record_type = "A"
#   target      = "192.168.1.121"
#   priority    = 0
#   ttl_sec     = 0
#   weight      = 0
# }

# resource "linode_domain_record" "nas" {
#   domain_id   = linode_domain.this.id
#   name        = "nas"
#   record_type = "A"
#   target      = "192.168.115.136"
#   priority    = 0
#   ttl_sec     = 0
#   weight      = 0
# }
