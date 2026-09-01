// FIXME: This doesn't really make sense here
# resource "linode_token" "terraform" {
#   label  = "Terraform"
#   scopes = "*"
# }

resource "linode_token" "npm" {
  label  = "Nginx Proxy Manager"
  scopes = "domains:read_write"
}

