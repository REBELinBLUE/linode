resource "linode_stackscript" "bootstrap" {
  label = "bootstrap"

  description = "Bootstrap for my Ubuntu Linode"

  script = <<-EOT
    #!/bin/bash

    # <UDF name="admin_username" label="The default user account">
    # <UDF name="admin_pubkey" label="The default user account's public key">
    # <UDF name="hostname" label="The hostname for the new instance">

    source <ssinclude StackScriptID="1">

    ADMIN_PASSWORD=$(randomString)

    set -x
    set -e

    # Basic system setup
    get_started "" "$HOSTNAME" $(system_primary_ip)
    #system_set_hostname "$HOSTNAME"
    system_set_timezone Europe/London
    system_configure_ntp
    #system_add_host_entry $(system_primary_ip) "$HOSTNAME"

    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:fish-shell/release-3
    system_update
    system_install_package nginx fish

    # Secure server
    secure_server "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$ADMIN_PUBKEY"
    add_ports 80 443 22 # FIXME: 22 shouldn't be needed here but configure_basic_firewall called by secure_server does not seem to be setting it correctly
    save_firewall
    #automatic_security_updates

    curl -fsSL https://starship.rs/install.sh | bash -s -- -y

    #certbot_ssl $fqdn $soa_email_address nginx

    # Configure user profile
    #user_add_pubkey "$ADMIN_USERNAME" "$ADMIN_PUBKEY" # FIXME: Use all SSH keys from linode account?
    chsh -s /usr/bin/fish "$ADMIN_USERNAME"

    mkdir -p /home/$ADMIN_USERNAME/.config/fish/

    echo $ADMIN_PASSWORD >> /home/"${ADMIN_USERNAME}"/password.txt
    echo "starship init fish | source" >> /home/"${ADMIN_USERNAME}"/.config/fish/config.fish
    printf "[username]\nformat = \"[\$user](\$style) on \"\n\n[hostname]\nformat = \"[linode](\$style) in \"" >>  ~/.config/starship.toml

    chown -R "${ADMIN_USERNAME}":"${ADMIN_USERNAME}" /home/"${ADMIN_USERNAME}"/password.txt
    chown -R "${ADMIN_USERNAME}":"${ADMIN_USERNAME}" /home/"${ADMIN_USERNAME}"/.config/fish/
    chown -R "${ADMIN_USERNAME}":"${ADMIN_USERNAME}" /home/"${ADMIN_USERNAME}"/.config/starship.toml

    # FIXME: Expire password?

    # Cleanup
    #stackscript_cleanup
    all_set

    # Longview?
    
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}