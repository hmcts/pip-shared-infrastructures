
data "azuread_domains" "aad_domains" {
  provider     = azuread.ad_sub
  only_default = true
}

data "azuread_client_config" "ad" {
  provider = azuread.ad_sub
}

data "azuread_application" "apps" {
  for_each     = { for ad_app_name in var.ad_app_names : ad_app_name => ad_app_name }
  provider     = azuread.ad_sub
  display_name = each.value
}

resource "azuread_application_password" "app_pwds" {
  for_each              = { for ad_app in data.azuread_application.apps : ad_app.display_name => ad_app }
  provider              = azuread.ad_sub
  application_object_id = each.value.object_id
  display_name          = "${each.value.display_name}-pwd"
}

resource "random_uuid" "aad_scope_id" {}
resource "random_uuid" "client_scope_id" {}