locals {
  default_tags = ["managed_by:terraform"]

  instance_ipv4_address = one(linode_instance.ubuntu_23_10.ipv4)
  instance_ipv6_address = cidrhost(linode_instance.ubuntu_23_10.ipv6, 0)
  instance_swap_size    = 512
}