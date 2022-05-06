

resource "azurerm_api_management_subscription" "product" {
  count               = local.env_to_run_in
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg
  product_id          = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.apim_rg}/providers/Microsoft.ApiManagement/service/${local.apim_name}/products/${local.apim_product_name}"
  display_name        = "PIP Subscription"
  state               = "active"
  allow_tracing       = var.env == "prod" ? false : true
}