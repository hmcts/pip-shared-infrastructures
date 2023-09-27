locals {
  service_account_namespace = "default"
  service_account_name      = "pip-cp-service-account"
}

data "azurerm_user_assigned_identity" "app_cp_mi" {
  name                = "${var.product}-cp-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"

  depends_on = [
    module.kv_cp
  ]
}

resource "azurerm_federated_identity_credential" "pip_crime_federated_connection" {
  name                = "pip-${var.env}-crime-federated-credential"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.CRIME_AKS_OIDC_ISSUER
  parent_id           = data.azurerm_user_assigned_identity.app_cp_mi.id
  subject             = "system:serviceaccount:${local.service_account_namespace}:${local.service_account_name}"
}
