data "azuread_domains" "b2c_domains" {
  provider     = azuread.b2c_sub
  only_default = true
}

data "azuread_client_config" "ad" {
  provider = azuread.b2c_sub
}

resource "random_uuid" "b2c_scope_id" {}
resource "random_uuid" "client_scope_id" {}