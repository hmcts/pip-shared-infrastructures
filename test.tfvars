env                    = "test"
domain                 = "test.platform.hmcts.net"
b2c_extension_app_id   = "1b8fff00-b715-464b-b4eb-e31551819110"
jenkins_mi_client_id   = "f4e06bc2-c8a5-4643-8ce7-85023024abb8"
jenkins_mi_resource_id = "/subscriptions/6c4d2513-a873-41b4-afdd-b05a33206631/resourceGroups/managed-identities-ptl-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/jenkins-ptl-mi"
redis_sku              = "Basic"

apim_kv_mi_access = {
  "HMI" = {
    name  = "hmi-mi-test"
    value = "c0592fe7-7369-46c8-b55f-8b27300bcba4"
  }
}
