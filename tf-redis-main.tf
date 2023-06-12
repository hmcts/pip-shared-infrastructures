module "redis" {
  source                          = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product                         = var.product
  location                        = var.location
  env                             = var.env
  subnetid                        = data.azurerm_subnet.iaas.id
  common_tags                     = var.common_tags
  maxmemory_reserved              = "642"
  maxfragmentationmemory_reserved = "642"
  maxmemory_delta                 = "642"

}


module "keyvault_redis_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "REDIS-HOST"
      value = module.redis.host_name
      tags = {
        "source" : "Redis"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "REDIS-PORT"
      value = module.redis.redis_port
      tags = {
        "source" : "Redis"
      }
      content_type    = "",
      expiration_date = local.secret_expiry
    },
    {
      name  = "REDIS-PASSWORD"
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
