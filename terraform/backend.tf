terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "rebelinblue-terraform-state"
    key            = "linode.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
  }
}
