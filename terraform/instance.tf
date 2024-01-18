locals {
  instance_ipv4_address = one(linode_instance.main.ipv4)
  instance_ipv6_address = cidrhost(linode_instance.main.ipv6, 0)
}

resource "linode_instance" "main" {
  label = "linode4819236"

  type   = data.linode_instance_type.default.id
  region = data.linode_region.london.id

  # private_ip = false

  tags = ["managed_by:terraform"]

  backups_enabled = true
  #swap_size       = 256
  #resize_disk     = false
  #migration_type  = "cold"

  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 10
    network_out    = 10
    transfer_quota = 80
  }

  watchdog_enabled = true
}

resource "linode_instance_disk" "boot" {
  linode_id = linode_instance.main.id

  label      = "Ubuntu 16.04 LTS Disk"
  size       = linode_instance.main.specs.0.disk - linode_instance.main.swap_size
  filesystem = "ext4"

  # image = data.linode_image.ubuntu_16_04.id

  # authorized_keys = [ 
  #   linode_sshkey.onepassword.ssh_key,
  #   linode_sshkey.ipad.ssh_key,
  #   linode_sshkey.gpg,
  # ]

  # authorized_users = [ 
  #   data.linode_profile.me.username
  # ]

  # root_pass = "terr4form-test"
}

resource "linode_instance_disk" "swap" {
  linode_id = linode_instance.main.id

  label      = "256MB Swap Image"
  size       = linode_instance.main.swap_size
  filesystem = "swap"
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
}

resource "linode_rdns" "main_ipv4" {
  address            = local.instance_ipv4_address
  rdns               = var.domain_apex
  wait_for_available = false
}

resource "linode_rdns" "main_ipv6" {
  address            = local.instance_ipv6_address
  rdns               = var.domain_apex
  wait_for_available = false
}

# data "linode_instance_backups" "main" {
#   linode_id = linode_instance.main.id
# }
