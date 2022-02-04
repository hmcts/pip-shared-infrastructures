
locals {
  runbook_name    = "client_secrets.ps1"
  runbook_content = file("./resources/runbooks/${local.runbook_name}")

  start_date = formatdate("YYYY-MM-DD", timeadd(local.today, "24h"))
  start_time = "01:00:00"
}

resource "azurerm_automation_runbook" "client_serects" {
  name                    = "rotate-client-secrets"
  location                = azurerm_automation_account.automation_account.location
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  log_verbose             = var.env == "prod" ? "false" : "true"
  log_progress            = "true"
  description             = "This is a runbook to automate the renewal and recycling of Client Secrects"
  runbook_type            = "PowerShell"

  content = local.runbook_content
}

resource "azurerm_automation_variable_string" "target_tenant_id" {
  name                    = "targetTenantId"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = var.opt_tenant_id
}
resource "azurerm_automation_variable_string" "target_app_id" {
  name                    = "targetApplicationId"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = var.otp_client_id
}
resource "azurerm_automation_variable_string" "target_app_secret" {
  name                    = "targetApplicationSecret"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = var.OTP_CLIENT_SECRET
}
resource "azurerm_automation_variable_string" "environment" {
  name                    = "environment"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = var.env
}
resource "azurerm_automation_variable_string" "product" {
  name                    = "product"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = var.product
}
resource "azurerm_automation_variable_string" "key_vault_name" {
  name                    = "keyVaultName"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = local.key_vault_name
}

resource "azurerm_automation_schedule" "client_serects" {
  name                    = "rotate-client-secrets-schedule"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Day"
  interval                = 1
  start_time              = "${local.start_date}T${local.start_time}"
  description             = "This is a schedule to automate the renewal and recycling of Client Secrects"
}

resource "azurerm_automation_schedule" "client_serects_trigger_once" {
  name                    = "rotate-client-secrets-schedule-single-trigger"
  resource_group_name     = azurerm_automation_account.automation_account.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "OneTime"
  interval                = 1
  description             = "This is a one time trigger to automate the renewal and recycling of Client Secrects"
}