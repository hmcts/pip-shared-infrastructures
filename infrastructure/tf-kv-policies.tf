data "azurerm_user_assigned_identity" "aks_mi" {
  name                = "aks-${var.env}-mi"
  resource_group_name = "genesis-rg"
}

data "azuread_application" "cft_client" {
  display_name = "cft-client"
}

module "keyvault-policy" {
  source = "./modules/kv_access_policy"

  key_vault_id = module.kv.key_vault_id

  policies = {
    "cft-client" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azuread_application.cft_client.object_id
      key_permissions         = []
      secret_permissions      = ["get"]
      certificate_permissions = []
      storage_permissions     = []
    },
    "aks-${var.env}-mi" = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_user_assigned_identity.aks_mi.principal_id
      key_permissions         = []
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
      certificate_permissions = []
      storage_permissions     = []
    }
  }
}
