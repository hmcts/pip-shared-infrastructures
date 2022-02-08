locals {
  prefix               = "${var.product}-ss"
  prefix_no_special    = replace(local.prefix, "-", "")
  resource_group_name  = "${local.prefix}-${var.env}-rg"
  storage_account_name = "${local.prefix_no_special}sa${var.env}"
  key_vault_name       = "${local.prefix}-kv-${var.env}"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
  support_env          = var.env == "prod" || var.env == "demo" || var.env == "sbox" ? var.env : "stg"
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
  for_each     = { for otp_app_name in var.otp_app_names : otp_app_name => otp_app_name }
  provider     = azuread.otp_sub
  display_name = each.value
}

resource "azuread_application_password" "app_pwds" {
  for_each              = { for otp_app in data.azuread_application.apps : otp_app.display_name => otp_app }
  provider              = azuread.otp_sub
  application_object_id = each.value.object_id
  display_name          = "${each.value.display_name}-pwd"
}