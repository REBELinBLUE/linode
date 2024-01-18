data "linode_kernel" "latest" {
  id = "linode/latest-64bit"
}

data "linode_instance_type" "default" {
  id = "g6-nanode-1"
}

data "linode_region" "london" {
  id = "eu-west"
}

data "linode_region" "paris" {
  id = "fr-par"
}

data "linode_profile" "me" {}
