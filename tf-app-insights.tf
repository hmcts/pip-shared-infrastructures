
module "application_insights_java" "java" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env              = var.env
  product          = var.product
  name             = "${local.prefix}-${var.env}-java-appinsights"
  application_type = "java"

  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.java
  to   = module.application_insights_java.azurerm_application_insights.this
}

module "application_insights_nodejs" "nodejs" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env              = var.env
  product          = var.product
  name             = "${local.prefix}-${var.env}-nodejs-appinsights"
  application_type = "Node.JS"

  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.nodejs
  to   = module.application_insights_nodejs.azurerm_application_insights.this
}


resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.application_insights.connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "AZURE_APPINSGHTS_KEY" {
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.key-vault.key_vault_id
}
