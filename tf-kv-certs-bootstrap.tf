locals {
  bootstrap_certs = []
}

data "azurerm_key_vault_secret" "bootstrap_certs" {
  for_each     = { for cert in local.bootstrap_certs : cert => cert }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}
data "azurerm_key_vault_certificate" "bootstrap_certs" {
  for_each     = { for cert in local.bootstrap_certs : cert => cert }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "keyvault_ado_certs" {
  source = "./infrastructure/modules/kv_certs"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  certs = [
    for cert in data.azurerm_key_vault_secret.bootstrap_certs : {
      name         = cert.name
      cert_content = cert.value
      tags = {
        "source" : "bootstrap ${data.azurerm_key_vault.bootstrap_kv.name} certs"
      }
      key_size = lookup(data.azurerm_key_vault_certificate.bootstrap_certs, cert.name).certificate_policy.0.key_properties.0.key_size
      key_type = lookup(data.azurerm_key_vault_certificate.bootstrap_certs, cert.name).certificate_policy.0.key_properties.0.key_type
    }
  ]
  depends_on = [
    module.kv
  ]
}
