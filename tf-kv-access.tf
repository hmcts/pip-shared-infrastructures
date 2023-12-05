resource "azurerm_key_vault_access_policy" "github_access" {
  key_vault_id = module.kv.key_vault_id

  object_id = var.GITHUB_RUNNER_OBJECT_ID
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_access_policy" "cft_jenkins_access" {
  key_vault_id = module.kv.key_vault_id

  object_id = "ca6d5085-485a-417d-8480-c3cefa29df31"
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}

data "azurerm_api_management" "apim_metadata" {
  name                = local.apim_name
  resource_group_name = local.apim_rg
}

resource "azurerm_key_vault_access_policy" "apim_client_access" {
  key_vault_id = module.kv.key_vault_id

  object_id = data.azurerm_api_management.apim_metadata.identity[0].principal_id
  tenant_id = data.azurerm_api_management.apim_metadata.identity[0].tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
}
