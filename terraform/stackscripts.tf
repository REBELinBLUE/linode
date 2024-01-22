resource "linode_stackscript" "bootstrap" {
  label = "bootstrap"

  description = ""
  rev_note    = ""

  script = <<-EOT
    #!/bin/bash

    # <UDF name="hostname" label="The hostname for the new instace">
    # <UDF name="password" label="The password for my user">

    source <ssinclude StackScriptID="1">

    system_set_timezone Europe/London
    system_update

    #automatic_security_updates

    system_set_hostname $hostname

    user_add_sudo stephen $password
    enable_passwordless_sudo stephen

    # FIXME: Use SSH keys from linode account?
    user_add_pubkey stephen "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgnlCD5hNitroeqHKun4svSkQwkt6OcWkTyA0g66Wj5"

    apt-add-repository ppa:fish-shell/release-3

    system_update

    ssh_disable_root

    system_install_package nginx fish

    chsh -s /usr/bin/fish stephen

    enable_fail2ban

    stackscript_cleanup
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}