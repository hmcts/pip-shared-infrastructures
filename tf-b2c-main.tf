data "azuread_domains" "b2c_domains" {
  provider     = azuread.b2c_sub
  only_default = true
}

data "azuread_client_config" "ad" {
  provider = azuread.b2c_sub
}

resource "random_uuid" "b2c_scope_id" {}
resource "random_uuid" "client_scope_id" {}

locals {
  b2c_domain = data.azuread_domains.b2c_domains.domains.0.domain_name
  b2c_url    = "https://${local.b2c_domain}.b2clogin.com/${local.b2c_domain}.onmicrosoft.com"
}