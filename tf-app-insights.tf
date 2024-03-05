
module "application_insights_java" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env              = var.env
  product          = var.product
  override_name    = "${local.prefix}-${var.env}-java-appinsights"
  application_type = "java"

  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.java
  to   = module.application_insights_java.azurerm_application_insights.this
}

module "application_insights_nodejs" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=main"

  env              = var.env
  product          = var.product
  override_name    = "${local.prefix}-${var.env}-nodejs-appinsights"
  application_type = "Node.JS"

  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.nodejs
  to   = module.application_insights_nodejs.azurerm_application_insights.this
}

