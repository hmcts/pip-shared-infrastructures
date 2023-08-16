locals {
  env               = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"
  apim_name         = "sds-api-mgmt-${local.env}"
  apim_rg           = "ss-${local.env}-network-rg"
  apim_product_name = "${var.product}-product-${local.env}"
  env_to_run_in     = local.env == "stg" || local.env == "demo" || local.env == "sbox" || local.env == "prod" || local.env == "test" ? 1 : 0
}

module "apim_product" {
  count                 = local.env_to_run_in
  source                = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"
  api_mgmt_name         = local.apim_name
  api_mgmt_rg           = local.apim_rg
  approval_required     = false
  name                  = local.apim_product_name
  published             = true
  subscription_required = false
  product_policy        = file("./infrastructure/resources/product-policy.xml")
}
