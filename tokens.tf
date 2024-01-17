resource "linode_token" "terraform" {
  label  = "terraform"
  scopes = "*"
}

// FIXME: This doesn't really make sense here