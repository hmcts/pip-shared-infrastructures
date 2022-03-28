

module "keyvault_ad_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv_apim.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "ad-tenant-id"
      value = var.ad_tenant_id
      tags = {
        "source" : "ad Tenant"
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.kv_apim
  ]
}
