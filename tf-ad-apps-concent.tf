/*

Unable to use Service Principal to grant Admin Consent
https://docs.microsoft.com/en-us/answers/questions/503886/error-aadsts7000113-when-granting-admin-consent-fo.html

*/


/* # Before giving consent, wait. Sometimes Azure returns a 200, but not all services have access to the newly created applications/services.
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
      az login --service-principal --username ${var.ad_client_id} --password ${var.ad_CLIENT_SECRET} --tenant ${var.ad_tenant_id} --allow-no-subscriptions 
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
      az login --service-principal --username ${var.ad_client_id} --password ${var.ad_CLIENT_SECRET} --tenant ${var.ad_tenant_id} --allow-no-subscriptions 
      az ad app permission admin-consent --id ${each.value.application_id}
    EOT
  }
  depends_on = [
    null_resource.delay_before_consent
  ]
} */