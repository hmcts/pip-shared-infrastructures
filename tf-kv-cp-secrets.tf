module "keyvault_cp_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv_cp.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name            = "app-tenant-id"
      value           = data.azurerm_client_config.current.tenant_id
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]

  depends_on = [
    module.kv_cp
  ]
}
