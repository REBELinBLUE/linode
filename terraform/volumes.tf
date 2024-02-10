resource "linode_volume" "data" {
  label = "data"

  size   = 10
  region = data.linode_region.london.id

  tags = local.default_tags
}