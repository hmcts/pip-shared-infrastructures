resource "azurerm_role_assignment" "github_runner" {
  scope                = module.kv.key_vault_id
  role_definition_name = "Contributor"
  principal_id         = var.GITHUB_RUNNER_OBJECT_ID

  depends_on = [
    module.kv
  ]
}