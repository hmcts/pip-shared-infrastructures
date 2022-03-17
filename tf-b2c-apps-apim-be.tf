locals {
  ## List of Backend Application to expose to the APIM
  apim_be_apps = {
    "${var.product}-apim-data-managment-${var.env}" : {
      name = "${var.product}-apim-data-managment-${var.env}"
      client_access = [
        azuread_application.client_apim_app_hmi.application_id
      ]
    }
  }
}

resource "azuread_application" "backend_apim_apps" {
  provider         = azuread.b2c_sub
  for_each         = local.apim_be_apps
  display_name     = each.value.name
  owners           = [data.azuread_client_config.b2c.object_id]
  sign_in_audience = "AzureADMyOrg"


  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = each.value.client_access

  }

}
