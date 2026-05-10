terraform {
  required_version = "1.15.2"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "3.12.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.3.1"
    }
  }
}