data "azuread_domains" "b2c_domains" {
  provider     = azuread.b2c_sub
  only_initial = true
}

data "azuread_client_config" "ad" {
  provider = azuread.b2c_sub
}

resource "random_uuid" "b2c_scope_id" {}
resource "random_uuid" "client_scope_id" {}

locals {
  b2c_default_url = (length(regexall("\\.onmircosoft\\.com", local.ad_url)) > 0)

  b2c_domain = replace(replace(local.ad_url, ".onmicrosoft.com", ".b2clogin.com"), ".service.gov.uk", ".b2clogin.com")

  b2c_signin_endpoint     = var.env != "prod" ? "sign-in.pip-frontend.${var.domain}" : "sign-in.${local.ad_url}"
  b2c_signin_endpoint_url = var.env == "prod" ? "https://${local.b2c_signin_endpoint}/${local.ad_url}" : local.ad_endpoint_url

  ad_url          = var.env == "prod" ? var.domain : data.azuread_domains.b2c_domains.domains.0.domain_name
  ad_endpoint_url = "https://${local.b2c_domain}/${local.ad_url}"

  //This specific logic for staging is needed due to the pages in the user flows only pointing to Staging blob store.
  b2c_urls = var.env == "stg" ? [
    "https://${local.b2c_domain}",
    "https://${local.b2c_signin_endpoint}",
    "https://*.pip-frontend.test.platform.hmcts.net",
    "https://*.pip-frontend.demo.platform.hmcts.net",
    "https://*.pip-frontend.ithc.platform.hmcts.net",
    ] : [
    "https://${local.b2c_domain}",
    "https://${local.b2c_signin_endpoint}"
  ]
}
