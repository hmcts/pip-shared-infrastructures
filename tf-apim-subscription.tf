

resource "azurerm_api_management_subscription" "product" {
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg
  product_id          = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.apim_rg}/providers/Microsoft.ApiManagement/service/${local.apim_name}/products/${module.apim_product[0].product_id}"
  display_name        = "PIP Subscription"
  state               = "active"
  allow_tracing       = var.env == "prod" ? false : true
}