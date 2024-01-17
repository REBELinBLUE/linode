resource "linode_object_storage_bucket" "terraform" {
  cluster = "fr-par-1"
  label   = "rebelinblue-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

// FIXME: This doesn't really make sense here
# resource "linode_object_storage_key" "terraform" {
#   label = "terraform"

#   bucket_access {
#     bucket_name = linode_object_storage_bucket.terraform.label
#     cluster     = linode_object_storage_bucket.terraform.cluster
#     permissions = "read_write"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }
