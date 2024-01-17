resource "linode_domain" "this" {
  type        = "master"
  domain      = "cluster.rebelinblue.com"
  soa_email   = var.soa_email
  refresh_sec = 300
  retry_sec   = 300
  ttl_sec     = 300
  tags        = ["managed_by:terraform"]
}

resource "linode_domain_record" "cname" {
  for_each = toset([
    "alertmanager", "auth", "blackbox",
    "cluster", "dashboard", "grafana",
    "kubeview", "launchpad", "prometheus",
    "promtail", "pushgateway", "traefik",
    "weave-gitops"
  ])

  domain_id   = linode_domain.this.id
  name        = each.value
  record_type = "CNAME"
  target      = var.cluster_address
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}
