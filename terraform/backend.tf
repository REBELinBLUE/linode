terraform {
  backend "s3" {
    bucket = "rebelinblue-terraform-state"
    key    = "terraform-state.tfstate"
    region = "fr-par-1"

    endpoints = {
      s3 = "https://fr-par-1.linodeobjects.com"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
