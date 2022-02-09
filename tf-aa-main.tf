

resource "azurerm_automation_account" "automation_account" {
  name                = "${local.prefix}-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.automation_account_sku_name

  tags = var.common_tags
}


module "automation_runbook_client_secret_rotation" {
  source = "git@github.com:hmcts/cnp-module-automation-runbook-sp-recycle?ref=master"

  resource_group_name = azurerm_resource_group.rg.name

  application_id_collection = [
    for otp_app in data.azuread_application.apps : otp_app.id
  ]

  environment = var.env
  product     = var.product

  key_vault_name = module.kv.key_vault_name

  automation_account_name = azurerm_automation_account.automation_account.name

  target_tenant_id          = var.opt_tenant_id
  target_application_id     = var.otp_client_id
  target_application_secret = var.OTP_CLIENT_SECRET

  source_managed_identity_id = var.jenkins_mi_object_id

  tags = var.common_tags
}
