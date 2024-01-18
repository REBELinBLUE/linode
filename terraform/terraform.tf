terraform {
  required_version = "1.6.6"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.13.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "1.4.1-beta01"
    }
  }
}