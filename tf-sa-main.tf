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
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=4.x"

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
    {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "OPTIONS"]
      allowed_origins    = local.b2c_urls
      exposed_headers    = ["*"]
      max_age_in_seconds = 200
    }
  ]

  //This figure should be reviewed regularly / updated if required
  defender_malware_scanning_cap_gb_per_month = 50
  defender_sensitive_data_discovery_enabled  = true
  defender_malware_scanning_enabled          = true
  defender_enabled                           = true

  //Currently set to false as not all subscriptions are on the same plan yet. Once subscriptions are updated,
  //we can then change this to true and configure the above per environment
  defender_override_subscription_level_settings = false

  tables     = local.tables
  containers = local.containers

  managed_identity_object_id = data.azurerm_user_assigned_identity.app_mi.principal_id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]
}
