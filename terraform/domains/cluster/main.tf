resource "linode_domain" "this" {
  type        = "master"
  domain      = "cluster.${var.domain_apex}"
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = var.default_tags
}

resource "linode_domain_record" "cname" {
  for_each = toset([
    "alertmanager", "auth", "blackbox",
    "dashboard", "grafana", "kubeview",
    "launchpad", "prometheus", "alloy",
    "pushgateway", "traefik", "argocd",
  ])

  domain_id   = linode_domain.this.id
  name        = each.value
  record_type = "CNAME"
  target      = var.cluster_address
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}
