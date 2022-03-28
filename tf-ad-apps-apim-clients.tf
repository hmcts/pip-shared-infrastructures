
resource "azuread_application" "client_apim_app_hmi" {
  provider         = azuread.ad_sub
  display_name     = "${var.product}-apim-app-hmi-${var.env}"
  owners           = [data.azuread_client_config.ad.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = []
  }
}
