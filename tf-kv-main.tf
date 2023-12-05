locals {
  b2c_tag          = "Azure b2c Tenant ${var.B2C_TENANT_ID}"
  bootstrap_prefix = "${var.product}-bootstrap-${var.env}"
}

module "kv" {
  source = "git@github.com:hmcts/cnp-module-key-vault?ref=master"

  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = true
}


data "azurerm_key_vault" "bootstrap_kv" {
  name                = "${local.bootstrap_prefix}-kv"
  resource_group_name = "${local.bootstrap_prefix}-rg"
}

data "azurerm_api_management" "apim_metadata" {
  name                = local.apim_name
  resource_group_name = local.apim_rg
}

resource "azurerm_key_vault_access_policy" "apim_client_access" {
  key_vault_id = module.kv.key_vault_id

  object_id = data.azurerm_api_management.apim_metadata.identity.principal_id
  tenant_id = data.azurerm_api_management.apim_metadata.identity.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}
