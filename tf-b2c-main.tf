data "azuread_domains" "b2c_domains" {
  provider     = azuread.b2c_sub
  only_default = true
}

data "azuread_client_config" "ad" {
  provider = azuread.b2c_sub
}

## TODO: Remove these once new B2C is created
data "azuread_application" "apps" {
  for_each     = { for ad_app_name in var.b2c_app_names : ad_app_name => ad_app_name }
  provider     = azuread.b2c_sub
  display_name = each.value
}

resource "azuread_application_password" "app_pwds" {
  for_each              = { for ad_app in data.azuread_application.apps : ad_app.display_name => ad_app }
  provider              = azuread.b2c_sub
  application_object_id = each.value.object_id
  display_name          = "${each.value.display_name}-pwd"
}

resource "random_uuid" "b2c_scope_id" {}
resource "random_uuid" "client_scope_id" {}