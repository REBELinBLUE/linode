
resource "linode_firewall" "default" {
  label = "Default"

  inbound {
    label  = "allow-inbound-http"
    action = "ACCEPT"

    protocol = "TCP"
    ports    = 80

    ipv4 = ["0.0.0.0/0"]
    ipv6 = ["::/0"]
  }

  inbound {
    label  = "allow-inbound-https"
    action = "ACCEPT"

    protocol = "TCP"
    ports    = 443

    ipv4 = ["0.0.0.0/0"]
    ipv6 = ["::/0"]
  }

  inbound {
    label  = "allow-inbound-ssh"
    action = "ACCEPT"

    protocol = "TCP"
    ports    = 22

    ipv4 = ["0.0.0.0/0"] // FIXME: Change to my IP
    //ipv6     = ["::/0"]
  }

  inbound_policy = "DROP"

  # outbound {
  #   label    = "reject-outbound-http"
  #   action   = "DROP"
  #
  #   protocol = "TCP"
  #   ports    = 80
  #
  #   ipv4     = ["0.0.0.0/0"]
  #   ipv6     = ["::/0"]
  # }

  # outbound {
  #   label    = "reject-outbound-https"
  #   action   = "DROP"
  #
  #   protocol = "TCP"
  #   ports    = 443
  #
  #   ipv4     = ["0.0.0.0/0"]
  #   ipv6     = ["::/0"]
  # }

  outbound_policy = "ACCEPT"

  //linodes = [linode_instance.main.id]
  //nodebalancers = []
  tags = local.default_tags
}

resource "linode_firewall_device" "main" {
  firewall_id = linode_firewall.default.id
  entity_id   = linode_instance.main.id
}
