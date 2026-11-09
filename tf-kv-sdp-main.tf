locals {
  sdp_key_vault_name = "${local.prefix}-sdp-kv-${var.env}"
}

module "kv_sdp" {
  source                   = "git@github.com:hmcts/cnp-module-key-vault?ref=DTSPO-31965/remove-jenkins-ptl-access"
  name                     = local.sdp_key_vault_name
  product                  = "${var.product}-sdp"
  env                      = var.env
  object_id                = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
  jenkins_object_id        = data.azurerm_user_assigned_identity.jenkins.principal_id
  grant_dev_jenkins_access = var.env == "stg"
  resource_group_name      = azurerm_resource_group.rg.name
  product_group_name       = var.active_directory_group
  common_tags              = var.common_tags
  create_managed_identity  = true
}
