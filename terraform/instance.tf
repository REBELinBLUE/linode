# resource "linode_instance" "main" {
#     region = "eu-west"
# }

data "linode_instances" "instances" {

}

locals {
  instance_ipv4_address = one(data.linode_instances.instances.instances.0.ipv4)
  instance_ipv6_address = cidrhost(data.linode_instances.instances.instances.0.ipv6, 0)
}