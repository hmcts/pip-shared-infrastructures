
##TODO: convert to module
resource "azurerm_automation_account" "automation_account" {
  name                = "${local.prefix}-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.automation_account_sku_name

  tags = var.common_tags
}

# Create an Automation Account that uses a user-assigned Managed Identity
# This is currently (Jan 2022) done using an ARM template

resource "azurerm_resource_group_template_deployment" "automation_account_mi_assignment" {
  name                = "automation-account-mi-assignment-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name

  # "Incremental" ADDS the resource to already existing resources. "Complete" destroys all other resources and creates the new one
  deployment_mode     = "Incremental"

  # the parameters below can be found near the top of the ARM file
  parameters_content = jsonencode({
    "automationAccount_name" = {
      value = azurerm_automation_account.automation_account.name
    },
    "my_location" = {
      value = azurerm_resource_group.rg.location
    },
    "userAssigned_identity" = {
      value = var.jenkins_mi_object_id
    }
  })
  # the actual ARM template file we will use
  template_content = file("./infrastructure/resources/arm-templates/ARM-user-assigned-mi.json")

  tags = var.tags

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

##TODO: get mi from data resource
  source_managed_identity_id = var.jenkins_mi_object_id

  tags = var.common_tags
}
