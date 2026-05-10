terraform {
  backend "s3" {
    use_lockfile = true
    encrypt      = true
    bucket       = "rebelinblue-terraform-state"
    key          = "linode.tfstate"
    region       = "eu-west-2"
  }
}
