resource "linode_stackscript" "bootstrap" {
  label = "bootstrap"

  description = "Bootstrap for my Ubuntu Linode"

  script = <<-EOT
    #!/bin/bash

    # <UDF name="username" label="The default user account" default="stephen" />
    # <UDF name="password" label="The password for the default user account" />
    # <UDF name="pubkey" label="The default user account's public key" />
    # <UDF name="hostname" label="The hostname for the new instance" />

    source <ssinclude StackScriptID="1">

    set -x

    # Basic system setup
    system_set_hostname "$hostname"
    system_set_timezone Europe/London
    system_configure_ntp
    system_add_host_entry $(system_primary_ip) "$hostname"

    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:fish-shell/release-3
    system_update
    system_install_package nginx fish

    # Secure server
    secure_server "$username" "$password" "$pubkey"
    add_port 'ipv4' 80 'tcp'
    add_port 'ipv6' 80 'tcp'
    add_port 'ipv4' 443 'tcp'
    add_port 'ipv6' 443 'tcp'
    #automatic_security_updates

    # Configure user profile
    #user_add_pubkey "$username" "$pubkey" # FIXME: Use all SSH keys from linode account?
    chsh -s /usr/bin/fish "$username"

    # Cleanup
    #stackscript_cleanup
    all_set
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}