# resource "linode_instance" "ubuntu_23_10" {
#   # label = "linode54223277"

#   type   = data.linode_instance_type.default.id
#   region = data.linode_region.london.id

#   # private_ip = false

#   tags = local.default_tags

#   backups_enabled = false
#   swap_size       = 512
#   #resize_disk     = false
#   #migration_type  = "cold"

#   alerts {
#     cpu            = 90
#     io             = 10000
#     network_in     = 10
#     network_out    = 10
#     transfer_quota = 80
#   }

#   watchdog_enabled = true
# }

# resource "random_string" "password" {
#   length  = 16
#   special = true
# }

# output "password" {
#   value = random_string.password.result
# }

# resource "linode_instance_disk" "ubuntu_23_10_boot" {
#   linode_id = linode_instance.ubuntu_23_10.id

#   label      = "Boot"
#   size       = data.linode_instance_type.default.disk - 512
#   # size       = data.linode_instance_type.default.disk - linode_instance.ubuntu_23_10.swap_size # FIXME This isn't working, sometimes it is 0 and creating an inconsistent plan
#   filesystem = "ext4"

#   image = data.linode_image.ubuntu_23_10.id

#   authorized_keys = [
#     linode_sshkey.onepassword.ssh_key,
#     linode_sshkey.ipad.ssh_key,
#     linode_sshkey.gpg.ssh_key,
#   ]

#   authorized_users = [
#     data.linode_profile.me.username
#   ]

#   root_pass = random_string.password.result
# }

# resource "linode_instance_disk" "ubuntu_23_10_swap" {
#   linode_id = linode_instance.ubuntu_23_10.id

#   label      = "Swap Image"
#   size       = 512
#   # size       = linode_instance.ubuntu_23_10.swap_size # FIXME This isn't working, sometimes it is 0 and creating an inconsistent plan
#   filesystem = "swap"
# }

# resource "linode_instance_config" "ubuntu_23_10" {
#   linode_id = linode_instance.ubuntu_23_10.id

#   booted = true

#   label = "Ubuntu 23.10 Profile"

#   virt_mode    = "paravirt"
#   kernel       = data.linode_kernel.latest.id
#   run_level    = "default"
#   memory_limit = 0

#   device {
#     device_name = "sda"
#     disk_id     = linode_instance_disk.ubuntu_23_10_boot.id
#   }

#   device {
#     device_name = "sdb"
#     disk_id     = linode_instance_disk.ubuntu_23_10_swap.id
#   }

#   # device {
#   #   device_name = "sdc"
#   #   volume_id   = linode_volume.data.id
#   # }

#   root_device = "/dev/sda"

#   interface {
#     primary = true
#     purpose = "public"
#   }

#   helpers {
#     devtmpfs_automount = true
#     distro             = true
#     modules_dep        = true
#     network            = true
#     updatedb_disabled  = true
#   }
# }
