locals {
  service_account_namespace = "default"
  service_account_name      = "pip-${var.env}-cp-service-account"
  mi_resource_group_name    = "managed-identities-${var.env}-rg"
  crime_oidc_json_config    = jsondecode(var.CRIME_OIDC_ISSUER_CONFIG)
}

data "azurerm_user_assigned_identity" "app_cp_mi" {
  name                = "${var.product}-cp-${var.env}-mi"
  resource_group_name = local.mi_resource_group_name

  depends_on = [
    module.kv_cp
  ]
}



resource "azurerm_federated_identity_credential" "pip_crime_federated_connection" {
  count = length(local.crime_oidc_json_config.connections)

  name                = "pip-${var.env}-crime-federated-credential-${local.crime_oidc_json_config.connections[count.index].name}"
  resource_group_name = local.mi_resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = local.crime_oidc_json_config.connections[count.index].issuer
  parent_id           = data.azurerm_user_assigned_identity.app_cp_mi.id
  subject             = local.crime_oidc_json_config.connections[count.index].subject
}
