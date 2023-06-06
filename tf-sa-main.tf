locals {
  tables = ["distributionlist", "courts"]
  containers = [{
    name        = "artefact"
    access_type = "private"
    },
    {
      name        = "files"
      access_type = "private"
    },
    {
      name        = "publications"
      access_type = "private"
    },
    {
      name        = local.b2c_container_name
      access_type = "container"
  }]
  b2c_container_name = "b2c-custom-policy-files"
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

  account_tier                    = var.sa_account_tier
  account_kind                    = var.sa_account_kind
  account_replication_type        = var.sa_account_replication_type
  access_tier                     = var.sa_access_tier
  allow_nested_items_to_be_public = "true"

  enable_data_protection = true

  enable_change_feed = true

  cors_rules = [
    for b2c_url in local.b2c_urls : {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "OPTIONS"]
      allowed_origins    = ["https://${b2c_url}"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 200
    }

  ]

  team_name    = var.team_name
  team_contact = var.team_contact

  tables     = local.tables
  containers = local.containers

  managed_identity_object_id = data.azurerm_user_assigned_identity.app_mi.principal_id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]
}
