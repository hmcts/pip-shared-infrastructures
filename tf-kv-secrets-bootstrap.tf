locals {
  base_bootstrap_secrets = [
    "gov-uk-notify-api-key",
    "pip-team-email",
    "auto-pip-${var.env}-courtel-api",
    "courtel-certificate",
    "crime-idam-client-id",
    "crime-idam-client-secret",
    "sso-client-id",
    "sso-client-secret",
    "sso-config-endpoint",
    "sso-sg-admin-ctsc",
    "sso-sg-admin-local",
    "sso-sg-super-admin-ctsc",
    "sso-sg-super-admin-local",
    "sso-sg-system-admin",
    "xhibit-s3-access-key",
    "xhibit-s3-access-key-secret",
    "cath-mi-client-id"
  ]

  dev_bootstrap_secrets = [
    "sso-client-id-dev",
    "sso-client-secret-dev",
    "sso-sg-admin-ctsc-dev",
    "sso-sg-admin-local-dev",
    "sso-sg-super-admin-ctsc-dev",
    "sso-sg-super-admin-local-dev",
    "sso-sg-system-admin-dev",
    "cath-mi-client-id"
  ]

  bootstrap_secrets = var.env == "stg" ? concat(local.base_bootstrap_secrets, local.dev_bootstrap_secrets) : local.base_bootstrap_secrets
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
        "source" : "bootstrap ${data.azurerm_key_vault.bootstrap_kv.name} secrets"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]
  depends_on = [
    module.kv
  ]
}
