locals {
  prefix              = "${var.product}-bootstrap-${var.env}"
  resource_group_name = "${local.prefix}-rg"
  key_vault_name      = "${local.prefix}-kv"
}

resource "azurerm_resource_group" "bootstrap_rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "boostrap_kv" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  resource_group_name     = azurerm_resource_group.bootstrap_rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  developers_group        = "DTS PIP Non-Prod"
  create_managed_identity = false
}
