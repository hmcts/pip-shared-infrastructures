resource "azurerm_key_vault_access_policy" "cath_mi_access_policy" {
  key_vault_id = module.kv_third_party.key_vault_id

  object_id = azurerm_user_assigned_identity.cath-mi[0].principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get", "List", "Set"]
  count                   = local.env == "prod" ? 0 : 1
  depends_on              = [module.kv_third_party]
}
