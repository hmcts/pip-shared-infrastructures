locals {
  env       = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"
  apim_name = "sds-api-mgmt-${local.env}"
}

module "apim_product" {
  count                 = local.env == "stg" || local.env == "sbox" ? 1 : 0
  source                = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"
  api_mgmt_name         = local.apim_name
  api_mgmt_rg           = "ss-${local.env}-network-rg"
  approval_required     = false
  name                  = "${var.product}-product-${local.env}"
  published             = true
  subscription_required = false
  product_policy        = file("./infrastructure/resources/product-policy.xml")
} 