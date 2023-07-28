resource "random_password" "session_string" {
  keepers = {
    expiry_date = "2024-03-01T01:00:00Z"
  }

  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  special     = true
}

resource "random_password" "idam_secret" {
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
      name  = "app-insights-nodejs-instrumentation-key"
      value = azurerm_application_insights.nodejs.instrumentation_key
      tags = {
        "source" = "App Insights"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "app-insights-java-instrumentation-key"
      value = azurerm_application_insights.java.instrumentation_key
      tags = {
        "source" = "App Insights"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "app-insights-java-connection-string"
      value = azurerm_application_insights.java.connection_string
      tags = {
        "source" = "App Insights"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "app-tenant-id"
      value           = data.azurerm_client_config.current.tenant_id
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "shared-storageaccount-key"
      value           = module.sa.storageaccount_primary_access_key
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "shared-storageaccount-connection-string"
      value           = module.sa.storageaccount_primary_connection_string
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "shared-storageaccount-name"
      value           = module.sa.storageaccount_name
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "session-key"
      value = random_password.session_string.result
      tags = {
        "purpose" = "b2c-session"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-tenant-id"
      value = var.B2C_TENANT_ID
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-auth-endpoint"
      value = "${local.ad_endpoint_url}/oauth2/v2.0/authorize" ##TODO: change to ad_url
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-config-endpoint"
      value = "${local.b2c_signin_endpoint_url}/B2C_1_SignInUserFlow/v2.0/.well-known/openid-configuration"
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-config-admin-endpoint"
      value = "${local.b2c_staff_endpoint_url}/B2C_1_SignInAdminUserFlow/v2.0/.well-known/openid-configuration"
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-url"
      value = local.b2c_signin_endpoint_url
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-ad-url"
      value = data.azuread_domains.b2c_domains.domains.0.domain_name
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "b2c-extension-app-id"
      value = var.b2c_extension_app_id
      tags = {
        "source" : local.b2c_tag
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "cft-idam-client-secret"
      value           = random_password.idam_secret.result
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]

  depends_on = [
    module.kv
  ]
}
