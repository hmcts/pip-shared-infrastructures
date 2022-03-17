resource "azurerm_key_vault_access_policy" "app_mi_access_policy" {
  key_vault_id = module.kv_apim.key_vault_id

  object_id = data.azurerm_user_assigned_identity.app_mi.client_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "set",
    "list",
    "get",
    "delete",
  ]
}
