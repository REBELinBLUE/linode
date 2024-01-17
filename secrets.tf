data "onepassword_vault" "personal" {
  name = "Personal"
}

# resource "onepassword_item" "demo_password" {
#   vault = data.onepassword_vault.personal.name

#   title    = "Demo Password Recipe"
#   category = "password"

#   password_recipe {
#     length  = 40
#     symbols = false
#   }
# }