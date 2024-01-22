locals {
  old_instance_swap_size = 256
}

resource "linode_instance" "main" {
  type   = data.linode_instance_type.default.id
  region = data.linode_region.london.id

  tags = local.default_tags

  backups_enabled = true

  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 10
    network_out    = 10
    transfer_quota = 80
  }

  watchdog_enabled = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_instance_disk" "boot" {
  linode_id = linode_instance.main.id

  label      = "Ubuntu 16.04 LTS Disk"
  size       = data.linode_instance_type.default.disk - local.old_instance_swap_size
  filesystem = "ext4"

  # image = data.linode_image.ubuntu_16_04.id

  # authorized_keys = [ 
  #   linode_sshkey.onepassword.ssh_key,
  #   linode_sshkey.ipad.ssh_key,
  #   linode_sshkey.gpg.ssh_key,
  # ]

  # authorized_users = [ 
  #   data.linode_profile.me.username
  # ]

  # root_pass = "terr4form-test"

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_instance_disk" "swap" {
  linode_id = linode_instance.main.id

  label      = "256MB Swap Image"
  size       = local.old_instance_swap_size
  filesystem = "swap"

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_instance_config" "main" {
  linode_id = linode_instance.main.id

  booted = true

  label = "My Ubuntu 16.04 LTS Profile"

  virt_mode    = "paravirt"
  kernel       = data.linode_kernel.latest.id
  run_level    = "default"
  memory_limit = 0

  device {
    device_name = "sda"
    disk_id     = linode_instance_disk.boot.id
  }

  device {
    device_name = "sdb"
    disk_id     = linode_instance_disk.swap.id
  }

  device {
    device_name = "sdc"
    volume_id   = linode_volume.data.id
  }

  root_device = "/dev/sda"

  interface {
    primary = true
    purpose = "public"
  }

  helpers {
    devtmpfs_automount = true
    distro             = true
    modules_dep        = true
    network            = true
    updatedb_disabled  = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_rdns" "main_ipv4" {
  address            = local.instance_ipv4_address
  rdns               = var.domain_apex
  wait_for_available = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_rdns" "main_ipv6" {
  address            = local.instance_ipv6_address
  rdns               = var.domain_apex
  wait_for_available = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "linode_firewall_device" "main" {
  firewall_id = linode_firewall.default.id
  entity_id   = linode_instance.main.id
}
