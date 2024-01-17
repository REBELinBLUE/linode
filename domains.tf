module "rebelinblue" {
  source = "./domains/rebelinblue"

  soa_email    = var.soa_email
  domain_apex  = var.domain_apex
  ipv4_address = local.instance_ipv4_address
  ipv6_address = local.instance_ipv6_address
}

module "cluster" {
  source = "./domains/cluster"

  soa_email       = var.soa_email
  domain_apex     = var.domain_apex
  cluster_address = var.firewalla_address
}

module "fastmail" {
  source = "./domains/fastmail"

  soa_email      = var.soa_email
  domain_apex    = var.domain_apex
  root_domain_id = module.rebelinblue.domain_id
}

module "phpdeployment" {
  source = "./domains/phpdeployment"

  soa_email    = var.soa_email
  ipv4_address = local.instance_ipv4_address
  ipv6_address = local.instance_ipv6_address
}
