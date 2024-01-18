locals {
  instance_ipv4_address = one(linode_instance.main.ipv4)
  instance_ipv6_address = cidrhost(linode_instance.main.ipv6, 0)
}

resource "linode_instance" "main" {
  label  = "linode4819236"
  type   = data.linode_instance_type.default.id
  region = data.linode_region.london.id

  private_ip  = false
  shared_ipv4 = []

  tags             = ["managed_by:terraform"]
  watchdog_enabled = true

  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 10
    network_out    = 10
    transfer_quota = 80
  }

  backups_enabled   = true
  swap_size         = 256
  resize_disk       = false
  migration_type    = "cold"
  boot_config_label = "My Ubuntu 16.04 LTS Profile"

  //booted            = true

  # backups           = [
  #     {
  #         available = true
  #         enabled   = true
  #         schedule  = [
  #             {
  #                 day    = "Scheduling"
  #                 window = "Scheduling"
  #             },
  #         ]
  #     },
  # ]

  # has_user_data     = false
  # host_uuid         = "a432c8a715e477b49dd349d21d1182502392cb83"
  //id                = "4819236"
  # ip_address        = "178.79.171.45"
  # ipv4              = [
  #     "178.79.171.45",
  # ]
  # ipv6              = "2a01:7e00::f03c:91ff:fe5e:b36f/128"


  # config {
  #   //id           = 57085365
  #   kernel       = "linode/latest-64bit"
  #   label        = "My Ubuntu 16.04 LTS Profile"
  #   memory_limit = 0
  #   root_device  = "/dev/sda"
  #   run_level    = "default"
  #   virt_mode    = "paravirt"

  #   devices {
  #     sda {
  #       disk_id    = 107033007
  #       disk_label = "Ubuntu 16.04 LTS Disk"
  #       volume_id  = 0
  #     }
  #     sdb {
  #       disk_id    = 107033008
  #       disk_label = "256MB Swap Image"
  #       volume_id  = 0
  #     }
  #   }

  #   helpers {
  #     devtmpfs_automount = true
  #     distro             = true
  #     modules_dep        = true
  #     network            = true
  #     updatedb_disabled  = true
  #   }
  # }

}

resource "linode_instance_disk" "boot" {
  linode_id = linode_instance.main.id

  label      = "Ubuntu 16.04 LTS Disk"
  size       = linode_instance.main.specs.0.disk - linode_instance.main.swap_size
  filesystem = "ext4"

  # image = "linode/ubuntu16.04"

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
  size       = 256
  filesystem = "swap"
}

resource "linode_instance_config" "main" {
  linode_id = linode_instance.main.id

  booted = true

  label  = "My Ubuntu 16.04 LTS Profile"
  kernel = data.linode_kernel.latest.id

  #memory_limit = 0

  #root_device  = "/dev/sda"
  #run_level    = "default"
  #virt_mode    = "paravirt"

  device {
    device_name = "sda"
    disk_id     = linode_instance_disk.boot.id
  }

  device {
    device_name = "sdb"
    disk_id     = linode_instance_disk.swap.id
  }

  # helpers {
  #   devtmpfs_automount = true
  #   distro             = true
  #   modules_dep        = true
  #   network            = true
  #   updatedb_disabled  = true
  # }
}
