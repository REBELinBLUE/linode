resource "linode_stackscript" "bootstrap" {
  label = "bootstrap"

  description = "Bootstrap for my Ubuntu Linode"

  script = <<-EOT
    #!/bin/bash

    # <UDF name="admin_username" label="The default username">
    # <UDF name="admin_password" label="The default password">
    # <UDF name="admin_pubkey" label="The default user account's public key">
    # <UDF name="dropshare_username" label="The dropshare username">
    # <UDF name="dropshare_pubkey" label="The dropshare user account's public key">
    # <UDF name="hostname" label="The hostname for the new instance">

    source <ssinclude StackScriptID="1">

    # Basic system setup
    get_started "" "$HOSTNAME" $(system_primary_ip)
    system_set_timezone Europe/London
    system_configure_ntp

    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:fish-shell/release-3
    system_update
    system_install_package nginx fish
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot

    # FIXME: Shouldn't be needed here but configure_basic_firewall called by secure_server remove ufw, after using it to allow port 22
    # https://www.linode.com/community/questions/24680/bug-in-stackscript-bash-library-configure_basic_firewall-on-ubuntu-2310
    system_remove_package ufw

    # Secure server
    secure_server "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$ADMIN_PUBKEY"
    add_ports 80 443
    save_firewall
    
    # automatic_security_updates

    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

    # Configure admin user profile
    # user_add_pubkey "$ADMIN_USERNAME" "$ADMIN_PUBKEY" # FIXME: Use all SSH keys from linode account?
    enable_passwordless_sudo "$ADMIN_USERNAME"

    chsh -s /usr/bin/fish "$ADMIN_USERNAME"

    mkdir -p /home/stephen/.config/fish/
    touch /home/$ADMIN_USERNAME/.config/fish/config.fish
    touch /home/$ADMIN_USERNAME/.config/starship.toml

    # echo $ADMIN_PASSWORD >> /home/$ADMIN_USERNAME/password.txt
    echo "starship init fish | source" >> /home/$ADMIN_USERNAME/.config/fish/config.fish
    printf "[username]\nformat = \"[\$user](\$style) on \"\n\n[hostname]\nformat = \"[linode](\$style) in \"" >>  /home/$ADMIN_USERNAME/.config/starship.toml

    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/password.txt
    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/.config/fish/
    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/.config/starship.toml

    # Mount volume
    mkdir /mnt/data
    echo "/dev/sdc 	 /mnt/data 	 ext4 	 defaults,noatime,nofail 0 2" >> /etc/fstab
    #mount /dev/sdc

    # Force the password to be changed
    passwd -e $ADMIN_USERNAME
    # fixme: delte the password instead? passwd -d $ADMIN_USERNAME

    # Add dropshare user
    adduser "$DROPSHARE_USERNAME" --disabled-password --gecos ""
    user_add_pubkey "$DROPSHARE_USERNAME" "$DROPSHARE_PUBKEY"
    echo "cd /mnt/data/var/www/dropshare" >> /users/$DROPSHARE_USERNAME/.profile

    # Configure longview?

    #certbot_ssl "test.rebelinblue.com" "stephen@rebelinblue.com" nginx
    #certbot -n --nginx --agree-tos --redirect -d "test.rebelinblue.com" -m "letsencrypt@stephen.rebelinblue.com"

    # Cleanup
    stackscript_cleanup
    all_set

    # Longview?
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}