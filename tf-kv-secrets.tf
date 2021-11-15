resource "random_password" "session_string" {
  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  special     = true
}

module "keyvault_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "otp-tenant-id"
      value = var.opt_tenant_id
      tags = {
        "source" : "OTP Tenant"
      }
      content_type = ""
    },
    {
      name         = "${module.sa.storageaccount_name}-storageaccount-key"
      value        = module.sa.storageaccount_primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "${module.sa.storageaccount_name}-storageaccount-connection-string"
      value        = module.sa.storageaccount_primary_connection_string
      tags         = {}
      content_type = ""
    },
    {
      name         = "${module.sa.storageaccount_name}-storageaccount-name"
      value        = module.sa.storageaccount_name
      tags         = {}
      content_type = ""
    },
    {
      name         = "${module.dtu_sa.storageaccount_name}-storageaccount-key"
      value        = module.dtu_sa.storageaccount_primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name  = "session-key"
      value = random_password.session_string.result
      tags = {
        "purpose" = "opt-session"
      }
      content_type = ""
    }
  ]

}

locals {
  bootstrap_prefix  = "${var.product}-bootstrap-${var.env}"
  bootstrap_secrets = ["gov-uk-notify-api-key"]
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
}

module "otp_apps" {
  for_each = { for otp_app_name in var.otp_app_names : otp_app_name => otp_app_name }
  source   = "./infrastructure/modules/ad-app"
  providers = {
    azuread = azuread.otp_sub
  }
  app_name = each.value
}

module "keyvault_otp_id_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    for otp_app in module.otp_apps : {
      name  = lower("otp-app-${otp_app.app_display_name}-id")
      value = otp_app.app_application_id
      tags = {
        "source" : "OTP Tenant"
      }
      content_type = ""
    }
  ]
}
module "keyvault_otp_id_pwds" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    for otp_app_pwd in module.otp_apps : {
      name  = lower("otp-app-${otp_app_pwd.pwd_display_name}")
      value = otp_app_pwd.pwd_value
      tags = {
        "source" : "OTP Tenant"
      }
      content_type = ""
    }
  ]
}