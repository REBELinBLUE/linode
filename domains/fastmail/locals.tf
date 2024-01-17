locals {
  domains = {
    tostring(linode_domain.this.domain) : linode_domain.this.id,
    tostring(var.domain_apex) : var.root_domain_id
  }
}