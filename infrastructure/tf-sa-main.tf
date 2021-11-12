#tfsec:ignore:azure-storage-default-action-deny
module "sa" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"

  env = var.env

  storage_account_name = local.storage_account_name
  common_tags          = var.common_tags

  default_action = "Allow"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = var.sa_account_replication_type
  access_tier              = var.sa_access_tier

  team_name    = var.team_name
  team_contact = var.team_contact
}

locals {
  tables = ["distributionlist", "courts", "artefact"]
}
resource "azurerm_storage_table" "sa_tables" {
  for_each             = { for table in local.tables : table => table }
  name                 = each.value
  storage_account_name = module.sa.storageaccount_name
  depends_on = [
    module.sa
  ]
}

#tfsec:ignore:azure-storage-default-action-deny
module "dtu_sa" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"

  env = var.env

  storage_account_name = "${local.storage_account_name}dtu"
  common_tags          = var.common_tags

  default_action = "Allow"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = "LRS"
  access_tier              = "Hot"

  team_name    = var.team_name
  team_contact = var.team_contact
}