
data "azuread_client_config" "b2c" {
  provider = azuread.b2c_sub
}

data "azuread_application" "apps" {
  for_each     = { for b2c_app_name in var.b2c_app_names : b2c_app_name => b2c_app_name }
  provider     = azuread.b2c_sub
  display_name = each.value
}

resource "azuread_application_password" "app_pwds" {
  for_each              = { for b2c_app in data.azuread_application.apps : b2c_app.display_name => b2c_app }
  provider              = azuread.b2c_sub
  application_object_id = each.value.object_id
  display_name          = "${each.value.display_name}-pwd"
}

resource "random_uuid" "aad_scope_id" {}
resource "random_uuid" "client_scope_id" {}