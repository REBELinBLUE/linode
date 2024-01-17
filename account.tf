resource "linode_account_settings" "this" {
  longview_subscription = null
  backups_enabled       = "false"
  network_helper        = "true"

  lifecycle {
    prevent_destroy = true
  }
}