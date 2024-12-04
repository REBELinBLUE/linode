data "linode_kernel" "latest" {
  id = "linode/latest-64bit"
}

data "linode_instance_type" "default" {
  id = "g6-nanode-1"
}

data "linode_region" "london" {
  id = "eu-west"
}

data "linode_image" "ubuntu_16_04" {
  id = "linode/ubuntu16.04lts"
}

data "linode_image" "ubuntu_23_10" {
  id = "linode/ubuntu23.10"
}

data "linode_image" "ubuntu_24_04" {
  id = "linode/ubuntu24.04"
}

data "linode_profile" "me" {}

data "onepassword_vault" "vault" {
  name = "Personal"
}

data "onepassword_item" "linode_root" {
  vault = data.onepassword_vault.vault.name
  uuid  = "sfm7xtuu2eejwoblmqbkxctlky"
}

data "onepassword_item" "linode_admin" {
  vault = data.onepassword_vault.vault.name
  uuid  = "lcvbjqaldxh5du2ca2cq54i35m"
}
