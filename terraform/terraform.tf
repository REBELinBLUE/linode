terraform {
  required_version = "1.6.6"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.31.1"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "2.1.2"
    }
  }
}