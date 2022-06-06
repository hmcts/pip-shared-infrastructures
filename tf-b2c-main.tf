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
  b2c_default_url = (length(regexall("\\.onmircosoft\\.com", data.azuread_domains.b2c_domains.domains.0.domain_name)) > 0)

  b2c_domain = replace(replace(data.azuread_domains.b2c_domains.domains.0.domain_name, ".onmicrosoft.com", ".b2clogin.com"), ".co.uk", ".b2clogin.com")

  ad_url          = data.azuread_domains.b2c_domains.domains.0.domain_name
  ad_endpoint_url = "https://${local.b2c_domain}/${local.ad_url}"

  b2c_urls = local.b2c_default_url ? [local.b2c_domain] : [
    "staff.${local.b2c_domain}",
    "sign-in.${local.b2c_domain}"
  ]
}