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

    curl -LJO https://github.com/topgrade-rs/topgrade/releases/download/v14.0.1/topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    tar zvxf topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    rm -f topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    mv topgrade /usr/local/bin

    # FIXME: Shouldn't be needed here but configure_basic_firewall called by secure_server remove ufw, after using it to allow port 22
    # https://www.linode.com/community/questions/24680/bug-in-stackscript-bash-library-configure_basic_firewall-on-ubuntu-2310
    system_remove_package ufw

    # Secure server
    secure_server "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$ADMIN_PUBKEY"
    add_ports 80 443 # FIXME: This stopped working, again
    save_firewall

    # iptables -A INPUT -p "tcp" --dport "80" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    # ip6tables -A INPUT -p "tcp" --dport "80" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

    # iptables -A INPUT -p "tcp" --dport "443" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    # ip6tables -A INPUT -p "tcp" --dport "443" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

    # apt install iptables-persistent
    # echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
    # echo iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
    
    # automatic_security_updates

    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

    # Configure admin user profile
    # user_add_pubkey "$ADMIN_USERNAME" "$ADMIN_PUBKEY" # FIXME: Use all SSH keys from linode account?
    enable_passwordless_sudo "$ADMIN_USERNAME"

    chsh -s /usr/bin/fish "$ADMIN_USERNAME"

    mkdir -p /home/stephen/.config/fish/
    touch /home/$ADMIN_USERNAME/.config/fish/config.fish
    touch /home/$ADMIN_USERNAME/.config/starship.toml

    echo "starship init fish | source" >> /home/$ADMIN_USERNAME/.config/fish/config.fish
    printf "[username]\nformat = \"[\$user](\$style) on \"\n\n[hostname]\nformat = \"[linode](\$style) in \"" >>  /home/$ADMIN_USERNAME/.config/starship.toml

    chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /home/$ADMIN_USERNAME/.config/
    # Mount volume
    mkdir /mnt/data
    echo "/dev/sdc 	 /mnt/data 	 ext4 	 defaults,noatime,nofail 0 2" >> /etc/fstab
    mount /dev/sdc

    # Add dropshare user
    adduser "$DROPSHARE_USERNAME" --disabled-password --gecos ""
    user_add_pubkey "$DROPSHARE_USERNAME" "$DROPSHARE_PUBKEY"
    echo "cd /mnt/data/var/www/dropshare" >> /users/$DROPSHARE_USERNAME/.profile

    # Configure longview?

    #certbot_ssl "test.rebelinblue.com" "stephen@rebelinblue.com" nginx

    # Cleanup
    stackscript_cleanup
    all_set

    # Longview?
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}