locals {
  tables = ["distributionlist", "courts", "artefact"]
}

#tfsec:ignore:azure-storage-default-action-deny
module "sa" {
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=master"

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

  tables = local.tables
}

#tfsec:ignore:azure-storage-default-action-deny
module "dtu_sa" {
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=master"

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