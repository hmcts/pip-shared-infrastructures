locals {
  bootstrap_resource_group_name = "${local.bootstrap_prefix}-rg"
  bootstrap_key_vault_name      = "${local.bootstrap_prefix}-kv"
}

resource "azurerm_resource_group" "bootstrap_rg" {
  name     = local.bootstrap_resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "boostrap_kv" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.bootstrap_key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  resource_group_name     = azurerm_resource_group.bootstrap_rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  developers_group        = "DTS PIP Non-Prod"
  create_managed_identity = false
}

data "azurerm_subscription" "current" {}

import {
  to = module.boostrap_kv.azurerm_key_vault.kv
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}/providers/Microsoft.KeyVault/vaults/${local.bootstrap_key_vault_name}"
}
