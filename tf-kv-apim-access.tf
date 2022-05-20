resource "azurerm_key_vault_access_policy" "app_mi_access_policy" {
  key_vault_id = module.kv_apim.key_vault_id

  object_id = data.azurerm_user_assigned_identity.app_mi.principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Set",
    "List",
    "Get",
    "Delete",
  ]
}

resource "azurerm_key_vault_access_policy" "client_access" {
  for_each = var.apim_kv_mi_access

  key_vault_id = module.kv_apim.key_vault_id

  object_id = each.value.value
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}