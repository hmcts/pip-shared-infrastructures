locals {
  prefix               = "${var.product}-ss"
  prefix_no_special    = replace(local.prefix, "-", "")
  resource_group_name  = "${local.prefix}-${var.env}-rg"
  storage_account_name = "${local.prefix_no_special}sa${var.env}"
  key_vault_name       = "${local.prefix}-kv-${var.env}"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

data "azurerm_subnet" "iaas" {
  name                 = "iaas"
  resource_group_name  = "ss-${var.env}-network-rg"
  virtual_network_name = "ss-${var.env}-vnet"
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
