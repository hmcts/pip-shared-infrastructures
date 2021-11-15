locals {
  prefix               = "${var.product}-sharedservice-${var.env}"
  resource_group_name  = "${local.prefix}-rg"
  storage_account_name = "${replace(local.prefix, "-", "")}sa"
  key_vault_name       = "${local.prefix}-kv"
  env_long_name        = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "apim_product" {
  source         = "git@github.com:hmcts/terraform-module-apim-product?ref=master"
  env            = var.env
  product        = var.product
  department     = "sds"
  product_policy = file("./infrastructure/resources/product-policy.xml")
}