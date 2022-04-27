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
      name         = "app-tenant-id"
      value        = data.azurerm_client_config.current.tenant_id
      tags         = {}
      content_type = ""
    },
    {
      name         = "shared-storageaccount-key"
      value        = module.sa.storageaccount_primary_access_key
      tags         = {}
      content_type = ""
    },
    {
      name         = "shared-storageaccount-connection-string"
      value        = module.sa.storageaccount_primary_connection_string
      tags         = {}
      content_type = ""
    },
    {
      name         = "shared-storageaccount-name"
      value        = module.sa.storageaccount_name
      tags         = {}
      content_type = ""
    },
    {
      name  = "session-key"
      value = random_password.session_string.result
      tags = {
        "purpose" = "b2c-session"
      }
      content_type = ""
    },
    {
      name  = "b2c-tenant-id"
      value = var.b2c_tenant_id
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    },
    {
      name  = "b2c-auth-endpoint"
      value = "https://${local.b2c_domain}.b2clogin.com/${local.b2c_domain}.onmicrosoft.com/oauth2/v2.0/authorize"
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    },
    {
      name  = "b2c-token-endpoint"
      value = "https://${local.b2c_domain}.b2clogin.com/${local.b2c_domain}.onmicrosoft.com/oauth2/v2.0/token"
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    },
    {
      name  = "b2c-extension-app-id"
      value = var.b2c_extension_app_id
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.kv
  ]
}


