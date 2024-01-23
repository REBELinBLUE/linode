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

    echo "export HOSTNAME=$HOSTNAME" >> /root/stackscript.txt
    echo "export ADMIN_USERNAME=$ADMIN_USERNAME" >> /root/stackscript.txt
    echo "export ADMIN_PASSWORD=$v" >> /root/stackscript.txt
    echo "export ADMIN_PUBKEY=\"$ADMIN_PUBKEY\"" >> /root/stackscript.txt

    # Basic system setup
    get_started "" "$HOSTNAME" $(system_primary_ip)
    system_set_timezone Europe/London
    system_configure_ntp

    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:fish-shell/release-3
    system_update
    system_install_package nginx fish

    # Secure server
    secure_server "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$ADMIN_PUBKEY"
    add_ports 80 443 22
    # FIXME: 22 shouldn't be needed here but configure_basic_firewall called by secure_server does not seem to be setting it correctly
    # https://www.linode.com/community/questions/24680/bug-in-stackscript-bash-library-configure_basic_firewall-on-ubuntu-2310
    save_firewall
    
    # automatic_security_updates

    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

    # certbot_ssl $fqdn $soa_email_address nginx

    # Configure user profile
    # user_add_pubkey "$ADMIN_USERNAME" "$ADMIN_PUBKEY" # FIXME: Use all SSH keys from linode account?

    chsh -s /usr/bin/fish "$ADMIN_USERNAME"

    mkdir -p /home/stephen/.config/fish/
    touch /home/$ADMIN_USERNAME/.config/fish/config.fish
    touch /home/$ADMIN_USERNAME/.config/starship.toml

    echo $ADMIN_PASSWORD >> /home/$ADMIN_USERNAME/password.txt
    echo "starship init fish | source" >> /home/$ADMIN_USERNAME/.config/fish/config.fish
    printf "[username]\nformat = \"[\$user](\$style) on \"\n\n[hostname]\nformat = \"[linode](\$style) in \"" >>  /home/$ADMIN_USERNAME/.config/starship.toml

    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/password.txt
    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/.config/fish/
    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/.config/starship.toml

    # FIXME: Expire password?

    passwd -e $ADMIN_USERNAME

    # Mount volume
    mkdir /mnt/data
    echo "/dev/sdc 	 /mnt/data 	 ext4 	 defaults,noatime,nofail 0 2" >> /etc/fstab

    # Cleanup
    stackscript_cleanup
    all_set

    # Longview?
    
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}