locals {
  secret_rotations = {
    "apps" : {
      key_vault_name = module.kv.key_vault_name
      application_id_collection = concat(
        [for app in azuread_application.frontend_apps : app.id],
        [for app in azuread_application.backend_apps : app.id]
      )
    },
    "apim_apps" : {
      key_vault_name = module.kv_apim.key_vault_name
      application_id_collection = concat(
        [for app in azuread_application.backend_apim_apps : app.id],
        [
          azuread_application.client_apim_app_hmi.id
        ]
      )
    }
  }
}


module "automation_runbook_client_secret_rotation" {
  for_each = local.secret_rotations
  source   = "git@github.com:hmcts/cnp-module-automation-runbook-app-recycle?ref=master"

  resource_group_name = azurerm_resource_group.rg.name

  application_id_collection = each.value.application_id_collection

  environment = var.env
  product     = var.product

  key_vault_name = each.value.key_vault_name

  automation_account_name = azurerm_automation_account.automation_account.name

  target_tenant_id          = var.b2c_tenant_id
  target_application_id     = var.b2c_client_id
  target_application_secret = var.B2C_CLIENT_SECRET

  source_managed_identity_id = data.azurerm_user_assigned_identity.app_mi.principal_id

  tags = var.common_tags

  depends_on = [
    module.kv,
    module.kv_apim,
    azuread_application.frontend_apps,
    azuread_application.backend_apps,
    azuread_application.backend_apim_apps,
    azuread_application.client_apim_app_hmi
  ]
}
