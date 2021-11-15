data "azurerm_user_assigned_identity" "aks_mi" {
  name                = "aks-${var.env}-mi"
  resource_group_name = "genesis-rg"
}

module "kv" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault.git?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = data.azurerm_user_assigned_identity.aks_mi.principal_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}