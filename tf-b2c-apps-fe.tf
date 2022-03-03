locals {
  fe_apps = {
    "${var.product}-frontend-${var.env}" : {
      name       = "${var.product}-frontend-${var.env}"
      url_prefix = (var.env == "prod" ? "www" : "${var.product}-frontend")
    }
  }
}

resource "azuread_application" "frontend_apps" {
  provider     = azuread.b2c_sub
  for_each     = local.fe_apps
  display_name = each.value.name
  #identifier_uris = ["https://pib2csbox.onmicrosoft.com/pip-OTP"]
  #logo_image       = filebase64("/path/to/logo.png")
  owners           = [data.azuread_client_config.b2c.object_id]
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = []

    oauth2_permission_scope {
      admin_consent_description  = "Administer access to ADD"
      admin_consent_display_name = "ADD Administer"
      enabled                    = true
      id                         = random_uuid.add_scope_id.result
      type                       = "Admin"
      value                      = "demo.read"
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