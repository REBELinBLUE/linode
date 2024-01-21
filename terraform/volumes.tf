resource "linode_volume" "data" {
  label = "data"
  size  = 10

  region    = linode_instance.main.region
  linode_id = linode_instance.main.id

  tags = local.default_tags
}