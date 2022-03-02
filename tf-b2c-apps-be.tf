locals {
  be_apps = {
    "${var.product}-account-management-${var.env}" : {
      name = "${var.product}-account-management-${var.env}"
    }
  }
}

resource "azuread_application" "backend_apps" {
  provider     = azuread.b2c_sub
  for_each     = local.be_apps
  display_name = each.value.name
  #identifier_uris = ["https://pib2csbox.onmicrosoft.com/pip-OTP"]
  #logo_image       = filebase64("/path/to/logo.png")
  owners           = [data.azuread_client_config.b2c.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = []


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
      id   = "741f803b-c850-494e-b5df-cde7c675a1ca" # User.ReadWrite.All
      type = "Role"
    }
  }

}