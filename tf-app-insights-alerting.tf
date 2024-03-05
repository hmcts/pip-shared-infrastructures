locals {
  alert_frequency_in_minutes = "5"
  warning_severity_level = "2"
}

data "azurerm_key_vault_secret" "action-group-email" {
  name         = "action-group-email"
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "action-group" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "CaTH Email Group"
  short_name             = "CaTH-Group"
  email_receiver_name    = "CaTH Email Group"
  email_receiver_address = data.azurerm_key_vault_secret.action-group-email.value
}

module "java-alerting" {
  source   = "git@github.com:hmcts/cnp-module-metric-alert"
  location = azurerm_resource_group.rg.location

  app_insights_name = local.java_appinsights_name

  alert_name             = "CaTH Java Exception Alerting"
  alert_desc             = "Triggers when java exceptions occurred within a 15 minutes interval"
  app_insights_query     = "exceptions"
  custom_email_subject   = "Exceptions in CaTH java applications"
  frequency_in_minutes   = local.alert_frequency_in_minutes
  time_window_in_minutes = local.alert_frequency_in_minutes
  severity_level         = local.warning_severity_level

  action_group_name          = module.action-group.action_group_name
  trigger_threshold          = "0"

  common_tags = var.common_tags
  resourcegroup_name = azurerm_resource_group.rg.name

  depends_on = [module.action-group]
}

module "nodejs_alerting" {
  source   = "git@github.com:hmcts/cnp-module-metric-alert"
  location = azurerm_resource_group.rg.location

  app_insights_name = local.nodejs_appinsights_name

  alert_name             = "CaTH Nodejs Exception Alerting"
  alert_desc             = "Triggers when nodejs exceptions occurred within a 15 minutes interval"
  app_insights_query     = "exceptions"
  custom_email_subject   = "Exceptions in CaTH nodejs application"
  frequency_in_minutes   = local.alert_frequency_in_minutes
  time_window_in_minutes = local.alert_frequency_in_minutes
  severity_level         = local.warning_severity_level

  action_group_name          = module.action-group.action_group_name
  trigger_threshold          = "0"

  common_tags = var.common_tags
  resourcegroup_name = azurerm_resource_group.rg.name

  depends_on = [module.action-group]
}

module "third_party_subscription_alerting" {
  source   = "git@github.com:hmcts/cnp-module-metric-alert"
  location = azurerm_resource_group.rg.location

  app_insights_name = local.java_appinsights_name

  alert_name             = "CaTH Courtel Subscription Error Alerting"
  alert_desc             = "Triggers when failing to send subscription to third party"
  app_insights_query     = "requests | where name == \"POST /notify/api\" and resultCode != 200"
  custom_email_subject   = "Error when sending subscription to third party"
  frequency_in_minutes   = local.alert_frequency_in_minutes
  time_window_in_minutes = local.alert_frequency_in_minutes
  severity_level         = local.warning_severity_level

  action_group_name          = module.action-group.action_group_name
  trigger_threshold          = "0"

  common_tags = var.common_tags
  resourcegroup_name = azurerm_resource_group.rg.name

  depends_on = [module.action-group]
}
