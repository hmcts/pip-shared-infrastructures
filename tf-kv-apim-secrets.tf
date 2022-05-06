locals {
  apim_tag = "APIM"
}

module "keyvault_apim_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv_apim.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "apim-subscription-key"
      value = local.env_to_run_in == 1 ? azurerm_api_management_subscription.product[0].primary_key : ""
      tags = {
        "source" : local.apim_tag
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.kv_apim
  ]
}
