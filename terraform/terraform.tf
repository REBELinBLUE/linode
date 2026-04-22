terraform {
  required_version = "1.6.6"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "3.11.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.3.1"
    }
  }
}