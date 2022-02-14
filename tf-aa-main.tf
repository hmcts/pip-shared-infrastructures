
##TODO: convert to module
resource "azurerm_automation_account" "automation_account" {
  name                = "${local.prefix}-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.automation_account_sku_name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.app_mi.id]
  }

  tags = var.common_tags
}

module "automation_runbook_client_secret_rotation" {
  source = "git@github.com:hmcts/cnp-module-automation-runbook-app-recycle?ref=master"

  resource_group_name = azurerm_resource_group.rg.name

  application_id_collection = [for b2c_app in data.azuread_application.apps : b2c_app.id]

  environment = var.env
  product     = var.product

  key_vault_name = module.kv.key_vault_name

  automation_account_name = azurerm_automation_account.automation_account.name

  target_tenant_id          = var.b2c_tenant_id
  target_application_id     = var.b2c_client_id
  target_application_secret = var.B2C_CLIENT_SECRET

  source_managed_identity_id = data.azurerm_user_assigned_identity.app_mi.principal_id

  tags = var.common_tags


  depends_on = [
    module.kv
  ]
}
