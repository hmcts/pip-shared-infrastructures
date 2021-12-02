data "azurerm_subnet" "core_infra_redis_subnet" {
  name                 = "core-infra-subnet-1-${local.env_long_name}"
  virtual_network_name = "core-infra-vnet-${local.env_long_name}"
  resource_group_name  = "core-infra-${local.env_long_name}"
}

module "redis" {
  source      = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product     = var.product
  location    = var.location
  env         = var.env
  subnetid    = data.azurerm_subnet.core_infra_redis_subnet.id
  common_tags = var.common_tags
}
