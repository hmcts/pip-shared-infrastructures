locals {
  java_appinsights_name   = "${local.prefix}-${var.env}-java-appinsights"
  nodejs_appinsights_name = "${local.prefix}-${var.env}-nodejs-appinsights"
}

resource "azurerm_application_insights" "java" {
  name                = local.java_appinsights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "java"
  tags                = var.common_tags
}

resource "azurerm_application_insights" "nodejs" {
  name                = local.nodejs_appinsights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "Node.JS"
  tags                = var.common_tags
}

data "azurerm_key_vault_secret" "action-group-email" {
  name         = "action-group-email"
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "java-alerting" {
  source   = "git@github.com:hmcts/cnp-module-metric-alert"
  location = azurerm_resource_group.rg.location

  app_insights_name = local.java_appinsights_name

  alert_name             = "Exceptions Alerting"
  alert_desc             = "Triggers when threshold of exceptions is met within a 5 minute interval."
  app_insights_query     = "traces | where message startswith \"Tomcat started on port\"" // This is a dummy query to test the alerting
  custom_email_subject   = "Exceptions Threshold Met"
  frequency_in_minutes   = 5
  time_window_in_minutes = 5
  severity_level         = "2"

  action_group_name          = module.action-group.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 2

  common_tags = var.common_tags

  resourcegroup_name = azurerm_resource_group.rg.name

  depends_on = [module.action-group]
}

module "action-group" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "CaTH Action Group"
  short_name             = "CaTH-Action-Group"
  email_receiver_name    = "The CaTH Email group"
  email_receiver_address = data.azurerm_key_vault_secret.action-group-email.value
}
