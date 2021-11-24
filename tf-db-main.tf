locals {
  postgresql_user = "pipdbadmin"
  db_name         = "shared"
}

data "azurerm_subnet" "postgres" {
  name                 = "iaas"
  resource_group_name  = "ss-${var.env}-network-rg"
  virtual_network_name = "ss-${var.env}-vnet"
}

module "database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=postgresql_tf"
  product            = var.product
  component          = var.component
  subnet_id          = data.azurerm_subnet.postgres.id
  location           = var.location
  env                = local.env_long_name
  postgresql_user    = local.postgresql_user
  database_name      = "shared"
  common_tags        = var.common_tags
  subscription       = local.env_long_name
  business_area      = "SDS"
  postgresql_version = 10

  key_vault_rg   = "genesis-rg"
  key_vault_name = "dtssharedservices${var.env}kv"
}