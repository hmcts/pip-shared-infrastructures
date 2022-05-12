locals {
  fe_apps = {
    "frontend" : {
      name       = "frontend"
      url_prefix = (var.env == "prod" ? "www" : "${var.product}-frontend")
    }
  }
}

resource "azuread_application" "frontend_apps" {
  provider         = azuread.b2c_sub
  for_each         = local.fe_apps
  display_name     = "${var.product}-${each.value.name}-${var.env}"
  owners           = [data.azuread_client_config.ad.object_id]
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = []

    oauth2_permission_scope {
      admin_consent_description  = "Administer access to ADD"
      admin_consent_display_name = "ADD Administer"
      enabled                    = true
      id                         = random_uuid.b2c_scope_id.result
      type                       = "Admin"
      value                      = "${each.value.name}.${var.env}.read"
      user_consent_description   = "Administer access to ADD"
      user_consent_display_name  = "ADD Administer"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182" # offline_access
      type = "Scope"
    }

    resource_access {
      id   = "37f7f235-527c-4136-accd-4a02d197296e" # openid
      type = "Scope"
    }

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
  }

  web {
    homepage_url = "https://${each.value.url_prefix}.${var.domain}"
    logout_url   = "https://${each.value.url_prefix}.${var.domain}/logout"
    redirect_uris = [
      "https://${each.value.url_prefix}.${var.domain}/login/return"
    ]

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = false
    }
  }

  lifecycle {
    ignore_changes = [
      web[0].redirect_uris
    ]
  }
}