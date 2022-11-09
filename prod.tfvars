env                    = "prod"
domain                 = "court-tribunal-hearings.service.gov.uk"
b2c_extension_app_id   = "c8cc99c7-01fc-4793-be32-54e8fc210b25"
jenkins_mi_client_id   = "f4e06bc2-c8a5-4643-8ce7-85023024abb8"
jenkins_mi_resource_id = "/subscriptions/6c4d2513-a873-41b4-afdd-b05a33206631/resourceGroups/managed-identities-ptl-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/jenkins-ptl-mi"

apim_kv_mi_access = {
  "HMI" = {
    name  = "hmi-mi-prod"
    value = "77377001-468e-4d2e-bff5-e02ecaed8bbd"
  },
  "ado" = {
    name  = "dcd_sp_ado_prod_operations_v2"
    value = "bc9dc74a-bbb4-4d97-b066-ea348584ea15"
  },
  "adov2" = {
    name  = "dcd_sp_ado_prod_operations_v2"
    value = "5d75fbe8-d598-4e6a-b3e0-93a09b504ab9"
  }
}
