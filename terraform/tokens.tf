// FIXME: This doesn't really make sense here
# resource "linode_token" "terraform" {
#   label  = "Terraform"
#   scopes = "*"
# }

resource "linode_token" "npm" {
  label  = "Nginx Proxy Manager"
  scopes = "domains:read_write"
}

# resource "linode_token" "external_dns" {
#   label  = "External DNS"
#   scopes = "domains:read_write"
# }

# FIXME: Add certbot token

# resource "onepassword_item" "linode" {
#   vault = data.onepassword_vault.vault.name

#    title    = "Example Item with Section Map"
#     category = "login"

# }

