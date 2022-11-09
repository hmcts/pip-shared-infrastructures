env                    = "stg"
domain                 = "staging.platform.hmcts.net"
b2c_extension_app_id   = "1b8fff00-b715-464b-b4eb-e31551819110"
jenkins_mi_client_id   = "f4e06bc2-c8a5-4643-8ce7-85023024abb8"
jenkins_mi_resource_id = "/subscriptions/6c4d2513-a873-41b4-afdd-b05a33206631/resourceGroups/managed-identities-ptl-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/jenkins-ptl-mi"

apim_kv_mi_access = {
  "HMI" = {
    name  = "hmi-mi-stg"
    value = "b0fd2d36-cc0b-400b-a383-f93f3e948c18"
  },
  "ado" = {
    name  = "dcd_sp_ado_stg_operations_v2"
    value = "338f0f74-6551-410d-a59a-3aad46cf6bb7" #"8dd23164-6278-4a1e-96f7-4e8f95067d8a"
  }
}
