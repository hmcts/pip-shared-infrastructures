locals {

  third_party_key_vault_name = "${local.prefix}-third-party-kv-${var.env}"
}

module "kv_third_party" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.third_party_key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}

resource "azurerm_key_vault_secret" "cath_mi_client_id" {
  name         = "cath-mi-client-id"
  value        = azurerm_user_assigned_identity.cath-mi.client_id
  key_vault_id = module.kv_third_party.key_vault_id

  depends_on = [
    azurerm_key_vault_access_policy.cath_mi_access_policy,
    module.kv
  ]
}
