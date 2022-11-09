resource "azurerm_automation_account" "automation_account" {
  name                = "${local.prefix}-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = var.automation_account_sku_name

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.app_mi.id,
      data.azurerm_user_assigned_identity.apim_mi.id,
      var.jenkins_mi_resource_id
    ]
  }

  tags = var.common_tags
}