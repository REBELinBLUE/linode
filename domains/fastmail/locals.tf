locals {
  domains = {
    tostring(linode_domain.this.domain) : linode_domain.this.id,
    tostring(var.domain_apex) : var.root_domain_id
  }

  number_of_domains = length(local.domains)
  domain_ids        = values(local.domains)
  domain_names      = keys(local.domains)
}