locals {
  secret_prefix = "${var.product}-${local.db_name}-POSTGRES"
}


module "keyvault_db_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name  = "${local.secret_prefix}-PASS"
      value = module.database.postgresql_password
      tags = {
        "source" : "PostgreSQL"
      }
      content_type = ""
    },
    {
      name  = "${local.secret_prefix}-HOST"
      value = module.database.host_name
      tags = {
        "source" : "PostgreSQL"
      }
      content_type = ""
    },
    {
      name  = "${local.secret_prefix}-USER"
      value = module.database.user_name
      tags = {
        "source" : "PostgreSQL"
      }
      content_type = ""
    },
    {
      name  = "${local.secret_prefix}-PORT"
      value = module.database.postgresql_listen_port
      tags = {
        "source" : "PostgreSQL"
      }
      content_type = ""
    },
    {
      name  = "${local.secret_prefix}-DATABASE"
      value = module.database.name
      tags = {
        "source" : "PostgreSQL"
      }
      content_type = ""
    }
  ]

  depends_on = [
    module.kv
  ]
}