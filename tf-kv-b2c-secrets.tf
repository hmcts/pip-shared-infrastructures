

module "keyvault_b2c_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv_apim.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "b2c-tenant-id"
      value = var.b2c_tenant_id
      tags = {
        "source" : "b2c Tenant"
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.kv_apim
  ]
}
