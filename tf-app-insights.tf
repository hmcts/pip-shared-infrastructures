
resource "azurerm_application_insights" "java" {
  name                = "${local.prefix}-${var.env}-java-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "java"
}

resource "azurerm_application_insights" "nodejs" {
  name                = "${local.prefix}-${var.env}-nodejs-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "Node.JS"
}