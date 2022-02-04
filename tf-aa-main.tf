

resource "azurerm_automation_account" "automation_account" {
  name                = "${local.prefix}-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.automation_account_sku_name

  tags = var.common_tags
}