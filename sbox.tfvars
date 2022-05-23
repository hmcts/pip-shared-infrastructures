env                    = "sbox"
domain                 = "sbox.platform.hmcts.net"
b2c_extension_app_id   = "1b8fff00-b715-464b-b4eb-e31551819110"
jenkins_mi_client_id   = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
jenkins_mi_resource_id = "/subscriptions/64b1c6d6-1481-44ad-b620-d8fe26a2c768/resourceGroups/managed-identities-ptlsbox-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/jenkins-ptlsbox-mi"

apim_kv_mi_access = {
  "HMI" = {
    name  = "hmi-mi-sbox"
    value = "7ac06558-a513-4259-b094-fef5d4de526b"
  },
  "ado" = {
    name  = "dcd_sp_ado_sbox_operations_v2"
    value = "5e76eeab-d22e-448f-bc0f-437b5e012307"
  }
}