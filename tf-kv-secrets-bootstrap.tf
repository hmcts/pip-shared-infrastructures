locals {
  bootstrap_prefix  = "${var.product}-bootstrap-${var.env}"
  bootstrap_secrets = ["gov-uk-notify-api-key", "b2c-test-account", "b2c-test-account-pwd", "pip-team-email"]
}
data "azurerm_key_vault" "bootstrap_kv" {
  name                = "${local.bootstrap_prefix}-kv"
  resource_group_name = "${local.bootstrap_prefix}-rg"
}

data "azurerm_key_vault_secret" "bootstrap_secrets" {
  for_each     = { for secret in local.bootstrap_secrets : secret => secret }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "keyvault_ado_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    for secret in data.azurerm_key_vault_secret.bootstrap_secrets : {
      name  = secret.name
      value = secret.value
      tags = {
        "source" : "bootstrap secrets"
      }
      content_type = ""
    }
  ]
  depends_on = [
    module.kv
  ]
}