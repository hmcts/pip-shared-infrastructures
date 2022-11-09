locals {
  secret_rotation_runbook_prefix = "secret-rotation"
  secret_rotations = {
    "apps" : {
      name           = "${local.secret_rotation_runbook_prefix}-b2c-apps"
      key_vault_name = module.kv.key_vault_name
      application_id_collection = concat(
        [for app in azuread_application.frontend_apps : app.id],
        [for app in azuread_application.backend_apps : app.id]
      )
      source_managed_identity_id = data.azurerm_user_assigned_identity.app_mi.client_id
    }
  }
}


module "automation_runbook_client_secret_rotation" {
  for_each = local.secret_rotations
  source   = "git@github.com:hmcts/cnp-module-automation-runbook-app-recycle?ref=master"

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name

  application_id_collection = each.value.application_id_collection

  environment = var.env
  product     = var.product

  key_vault_name = each.value.key_vault_name

  automation_account_name = azurerm_automation_account.automation_account.name

  target_tenant_id          = var.B2C_TENANT_ID
  target_application_id     = var.B2C_CLIENT_ID
  target_application_secret = var.B2C_CLIENT_SECRET

  source_managed_identity_id = var.jenkins_mi_client_id

  tags = var.common_tags

  depends_on = [
    module.kv,
    module.kv_apim,
    azuread_application.frontend_apps,
    azuread_application.backend_apps
  ]
}