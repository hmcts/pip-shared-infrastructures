module "redis" {
  source                          = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product                         = var.product + "-v6"
  location                        = var.location
  env                             = var.env
  subnetid                        = data.azurerm_subnet.iaas.id
  common_tags                     = var.common_tags
  business_area                   = "sds"
  redis_version                   = "6"

  private_endpoint_enabled      = true
  public_network_access_enabled = false
}


module "keyvault_redis_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "REDIS-V6-HOST"
      value = module.redis.host_name
      tags = {
        "source" : "Redis"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "REDIS-V6-PORT"
      value = module.redis.redis_port
      tags = {
        "source" : "Redis"
      }
      content_type    = "",
      expiration_date = local.secret_expiry
    },
    {
      name  = "REDIS-V6-PASSWORD"
      value = module.redis.access_key
      tags = {
        "source" : "Redis"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]

  depends_on = [
    module.redis
  ]
}
