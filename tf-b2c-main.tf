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

  b2c_staff_endpoint     = var.env == "stg" ? "staff.pip-frontend.staging.platform.hmcts.net" : "staff.${local.ad_url}"
  b2c_staff_endpoint_url = var.env == "prod" ? "https://${local.b2c_staff_endpoint}/${local.ad_url}" : local.ad_endpoint_url

  b2c_signin_endpoint     = var.env == "stg" ? "sign-in.pip-frontend.staging.platform.hmcts.net" : "sign-in.${local.ad_url}"
  b2c_signin_endpoint_url = var.env == "prod" ? "https://${local.b2c_signin_endpoint}/${local.ad_url}" : local.ad_endpoint_url

  ad_url          = var.env == "prod" ? var.domain : data.azuread_domains.b2c_domains.domains.0.domain_name
  ad_endpoint_url = "https://${local.b2c_domain}/${local.ad_url}"

  b2c_urls = [
    local.b2c_domain,
    local.b2c_staff_endpoint,
    local.b2c_signin_endpoint
  ]
}
