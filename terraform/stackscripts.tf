resource "linode_stackscript" "bootstrap" {
  label       = "bootstrap"
  description = "Bootstrap for my Ubuntu Linode"

  script = <<-EOT
    #!/bin/bash

    # <UDF name="admin_username" label="The default username">
    # <UDF name="admin_password" label="The default password">
    # <UDF name="admin_pubkey" label="The default user account's public key">
    # <UDF name="dropshare_username" label="The dropshare username">
    # <UDF name="dropshare_pubkey" label="The dropshare user account's public key">
    # <UDF name="hostname" label="The hostname for the new instance">

    function system_primary_ip {
      local ip_address="$(ip a | awk '/inet / {print $2}')"
      echo $ip_address | cut -d' ' -f 2 | cut -d/ -f 1
    }

    # Basic system setup
    local ip=$system_primary_ip()
    printf "Setting IP Address (%s) and hostname (%s) in /etc/hosts...\n" "$ip" "$HOSTNAME"

    # Force IPv4 and noninteractive upgrade after script runs to prevent
    # breaking nf_conntrack
    echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

    printf "Checking for initial updates...\n"
    DEBIAN_FRONTEND=noninteractive apt-get update -qq >/dev/null

    hostnamectl set-hostname "$HOSTNAME"
    timedatectl set-timezone "Europe/London"
    systemctl start systemd-timesyncd

    # Install packages
    DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:fish-shell/release-3
    DEBIAN_FRONTEND=noninteractive apt-get update -qq >/dev/null
    DEBIAN_FRONTEND=noninteractive apt-get -y install "nginx fish" -qq >/dev/null
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot

    curl -LJO https://github.com/topgrade-rs/topgrade/releases/download/v14.0.1/topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    tar zvxf topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    rm -f topgrade-v14.0.1-x86_64-unknown-linux-musl.tar.gz
    mv topgrade /usr/local/bin

    DEBIAN_FRONTEND=noninteractive apt-get -y purge ufw -qq >/dev/null

    # Secure server
    DEBIAN_FRONTEND=noninteractive apt-get -y install "sudo" -qq >/dev/null
    adduser "$ADMIN_USERNAME" --disabled-password --gecos ""
    echo "$ADMIN_USERNAME:$ADMIN_PASSWORD" | chpasswd
    # Add the newly created user to the 'sudo' group
    adduser "$ADMIN_USERNAME" sudo >/dev/null

    # Add user's SSH key
    mkdir -p /home/$ADMIN_USERNAME/.ssh
    chmod -R 700 /home/$ADMIN_USERNAME/.ssh/
    echo "$ADMIN_PUBKEY" >> /home/$ADMIN_USERNAME/.ssh/authorized_keys
    chown -R "$ADMIN_USERNAME":"$ADMIN_USERNAME" /home/$ADMIN_USERNAME/.ssh
    chmod 600 /home/$ADMIN_USERNAME/.ssh/authorized_keys

    # Disable root SSH access
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
    # Disable password authentication
    sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
    sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
    echo "PubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config
    # Restart SSHd
    systemctl restart ssh

    DEBIAN_FRONTEND=noninteractive apt-get -y install "iptables-persistent" -qq >/dev/null

    iptables --policy INPUT DROP
    iptables --policy OUTPUT ACCEPT
    iptables --policy FORWARD DROP
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -i lo -m comment --comment "Allow loopback connections" -j ACCEPT
    iptables -A INPUT -p icmp -m comment --comment "Allow Ping to work as expected" -j ACCEPT
    ip6tables --policy INPUT DROP
    ip6tables --policy OUTPUT ACCEPT
    ip6tables --policy FORWARD DROP
    ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A INPUT -i lo -m comment --comment "Allow loopback connections" -j ACCEPT
    ip6tables -A INPUT -p icmpv6 -m comment --comment "Allow Ping to work as expected" -j ACCEPT
    iptables -A INPUT -p "tcp" --dport "22" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A INPUT -p "tcp" --dport "22" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

    DEBIAN_FRONTEND=noninteractive apt-get -y install "fail2ban" -qq >/dev/null

    # Configure fail2ban defaults
    cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    sed -i -e "s/backend = auto/backend = systemd/" /etc/fail2ban/jail.local
    systemctl enable fail2ban
    systemctl start fail2ban

    iptables -A INPUT -p "tcp" --dport "80" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A INPUT -p "tcp" --dport "80" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p "tcp" --dport "443" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A INPUT -p "tcp" --dport "443" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

    printf "Saving firewall rules for IPv4 and IPv6...\n"
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

    # Automatic updates
    DEBIAN_FRONTEND=noninteractive apt-get -y install "unattended-upgrades" -qq >/dev/null
    echo "APT::Periodic::Update-Package-Lists \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades 
    echo "APT::Periodic::Download-Upgradeable-Packages \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades 
    echo "APT::Periodic::AutocleanInterval \"7\";" >> /etc/apt/apt.conf.d/20auto-upgrades 
    echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades 

    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

    # Configure admin user profile
    echo "$ADMIN_USERNAME ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

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

    # Configure longview, nginx and certbot
    # ln -s /mnt/data/etc/nginx/* /etc/nginx/site-enabled/
    # mkdir /var/log/nginx/dropshare.rebelinblue.com/
    # systemctl restart nginx
    # certbot -n --nginx --agree-tos --redirect -m letsencrypt@stephen.rebelinblue.com -d phpdeployment.org,www.phpdeployment.org
    # certbot -n --nginx --agree-tos --redirect -m letsencrypt@stephen.rebelinblue.com -d rebelinblue.com,www.rebelinblue.com
    # certbot -n --nginx --agree-tos --redirect -m letsencrypt@stephen.rebelinblue.com -d dropshare.rebelinblue.com

    # Cleanup
    printf "Running initial updates - This will take a while...\n"
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade >/dev/null

    # Force IPv4 and noninteractive upgrade after script runs to prevent breaking nf_conntrack for UFW
    echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
    # Clean up
    rm /root/StackScript
    rm /root/ssinclude*
    echo "Installation complete!"

    printf "The StackScript has completed successfully.\n"
    touch "/root/.ss-complete"
  EOT

  images = [data.linode_image.ubuntu_23_10.id]
}