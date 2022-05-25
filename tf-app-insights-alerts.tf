locals {
  alert_scopes = [
    azurerm_application_insights.nodejs.id,
    azurerm_application_insights.java.id
  ]

  errors_exceptions_threshold = 25
}

resource "azurerm_monitor_action_group" "main" {
  name                = "${local.prefix}-${var.env}-actiongroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "pip ${var.env} actiongroup"

  #arm_role_receiver {
  #  name                    = "role alerting"
  #  role_id                 = "de139f84-1756-47ae-9be6-808fbbe84772"
  #  use_common_alert_schema = true
  #}
}

resource "azurerm_monitor_metric_alert" "errors" {
  name                = "${local.prefix}-${var.env}-errors-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = local.alert_scopes
  description         = "Action will be triggered when Exceptions count is greater than ${local.errors_exceptions_threshold} per 5 minuutes."
  frequency           = "PT1M"
  severity            = 1
  window_size         = "PT5M"

  criteria {
    metric_namespace = "performanceCounters"
    metric_name      = "exceptionsPerSecond"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 50

    dimension {
      name     = "Cloud role instance"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}