module "rebelinblue" {
  source = "./domains/rebelinblue"

  soa_email    = var.soa_email
  domain_apex  = var.domain_apex
  ipv4_address = local.instance_ipv4_address
  ipv6_address = local.instance_ipv6_address
  default_tags = local.default_tags
}

module "cluster" {
  source = "./domains/cluster"

  soa_email       = var.soa_email
  domain_apex     = var.domain_apex
  cluster_address = var.firewalla_address
  default_tags    = local.default_tags
}

module "home" {
  source = "./domains/home"

  soa_email    = var.soa_email
  domain_apex  = var.domain_apex
  default_tags = local.default_tags
}

module "fastmail" {
  source = "./domains/fastmail"

  soa_email      = var.soa_email
  domain_apex    = var.domain_apex
  root_domain_id = module.rebelinblue.domain_id
  default_tags   = local.default_tags
}
