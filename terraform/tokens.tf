// FIXME: This doesn't really make sense here
resource "linode_token" "terraform" {
  label  = "terraform"
  scopes = "*"
}

resource "linode_token" "npm" {
  label  = "nginx proxy manager"
  scopes = "domains:read_write"
}
