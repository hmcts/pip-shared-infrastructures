locals {
  prefix               = "${var.product}-ss"
  resource_group_name  = "${local.prefix}-${var.env}-rg"
  storage_account_name = "${replace(local.prefix, "-", "")}sa"
  key_vault_name       = "${local.prefix}-kv-${var.env}"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
  support_env          = var.env != "prod" ? var.env != "sbox" ? "stg" : "sbox" : var.env
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}