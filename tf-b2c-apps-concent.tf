
# Before giving consent, wait. Sometimes Azure returns a 200, but not all services have access to the newly created applications/services.
resource "null_resource" "delay_before_consent" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    azuread_application.backend_apps,
    azuread_application.frontend_apps
  ]
}

# Give admin consent 
resource "null_resource" "be_grant_admin_constent" {
  for_each = azuread_application.backend_apps
  provisioner "local-exec" {
    command = <<-EOT
      az login --service-principal --username ${var.b2c_client_id} --password ${var.B2C_CLIENT_SECRET} --tenant ${var.b2c_tenant_id} --allow-no-subscriptions 
      az ad app permission admin-consent --id ${each.value.application_id}
    EOT
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
}
resource "null_resource" "fe_grant_admin_constent" {
  for_each = azuread_application.frontend_apps
  provisioner "local-exec" {
    command = <<-EOT
      az login --service-principal --username ${var.b2c_client_id} --password ${var.B2C_CLIENT_SECRET} --tenant ${var.b2c_tenant_id} --allow-no-subscriptions 
      az ad app permission admin-consent --id ${each.value.application_id}
    EOT
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
}