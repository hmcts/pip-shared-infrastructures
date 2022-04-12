module "keyvault_otp_id_secrets" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    for otp_app in data.azuread_application.apps : {
      name  = lower("otp-app-${otp_app.display_name}-id")
      value = otp_app.application_id
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    }
  ]
  depends_on = [
    module.kv
  ]
}
module "keyvault_otp_id_pwds" {
  source = "./infrastructure/modules/kv_secrets"

  key_vault_id = module.kv.key_vault_id
  tags         = var.common_tags
  secrets = [
    for otp_app_pwd in azuread_application_password.app_pwds : {
      name  = lower("otp-app-${otp_app_pwd.display_name}")
      value = otp_app_pwd.value
      tags = {
        "source" : local.b2c_tag
      }
      content_type = ""
    }
  ]
  depends_on = [
    module.kv
  ]
}