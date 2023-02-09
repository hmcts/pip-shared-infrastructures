locals {
  prefix               = "${var.product}-ss"
  prefix_no_special    = replace(local.prefix, "-", "")
  resource_group_name  = "${local.prefix}-${var.env}-rg"
  storage_account_name = "${local.prefix_no_special}sa${var.env}"
  key_vault_name       = "${local.prefix}-kv-${var.env}"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  frontend_url = "${var.env == "prod" ? "www" : "pip-frontend"}.${var.domain}"

  secret_expiry = "2024-03-01T01:00:00Z"
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

data "azurerm_subnet" "iaas" {
  name                 = "iaas"
  resource_group_name  = "ss-${var.env}-network-rg"
  virtual_network_name = "ss-${var.env}-vnet"
}



data "azurerm_user_assigned_identity" "app_mi" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"

  depends_on = [
    module.kv
  ]
}

data "azurerm_user_assigned_identity" "aks_mi" {
  name                = "aks-${var.env}-mi"
  resource_group_name = "genesis-rg"
}

data "azurerm_user_assigned_identity" "apim_mi" {
  name                = "${var.product}-apim-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"

  depends_on = [
    module.kv_apim
  ]
}
