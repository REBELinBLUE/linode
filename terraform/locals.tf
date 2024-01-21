locals {
  default_tags = ["managed_by:terraform"]

  instance_ipv4_address = one(linode_instance.main.ipv4)
  instance_ipv6_address = cidrhost(linode_instance.main.ipv6, 0)
}