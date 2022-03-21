locals {
  be_apps = {
    "account-management" : {
      name          = "account-management"
      client_access = [for app in azuread_application.frontend_apps : app.application_id]
    },
    "subscription-management" : {
      name          = "account-management"
      client_access = [for app in azuread_application.frontend_apps : app.application_id]
    },
    "data-management" : {
      name = "data-management"
      client_access = concat([
        azuread_application.client_apim_app_hmi.application_id,
        ],
        [for app in azuread_application.frontend_apps : app.application_id]
      )
    }
  }
}

resource "azuread_application" "backend_apps" {
  provider     = azuread.b2c_sub
  for_each     = local.be_apps
  display_name = "${var.product}-${each.value.name}-${var.env}"
  #identifier_uris = ["https://pib2csbox.onmicrosoft.com/pip-OTP"]
  #logo_image       = filebase64("/path/to/logo.png")
  owners           = [data.azuread_client_config.b2c.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = 2

    known_client_applications = each.value.client_access

    oauth2_permission_scope {
      admin_consent_description  = "API Authentication and Access"
      admin_consent_display_name = "API Access"
      enabled                    = true
      id                         = random_uuid.client_scope_id.result
      type                       = "Admin"
      value                      = "demo.read"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182" # offline_access
      type = "Scope"
    }

    resource_access {
      id   = "37f7f235-527c-4136-accd-4a02d197296e" # openid
      type = "Scope"
    }

    resource_access {
      id   = "741f803b-c850-494e-b5df-cde7c675a1ca" # User.ReadWrite.All
      type = "Role"
    }
  }

}

locals {
  be_app_string = join(" ", [for app in azuread_application.backend_apps : "\"${app.application_id}\""])
}

resource "null_resource" "be_know_clients" {
  for_each = azuread_application.backend_apps
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      az login --service-principal --username ${var.b2c_client_id} --password ${var.B2C_CLIENT_SECRET} --tenant ${var.b2c_tenant_id} --allow-no-subscriptions 

      appId="${each.value.application_id}"
      newClientApps=(${local.be_app_string})

      appDisplayName=$(az ad app list --query "[? appId=='$appId'].{displayName:displayName}" --all -o tsv)

      if [ -z $appDisplayName ]; then
        echo "NOT Found App $appDisplayName"
      else

        echo "Found App $appDisplayName"
        knownClientApps=$(az ad app show --id $appId --query "knownClientApplications" -o tsv)

        echo "Current Know Clients [$(
          IFS=$'\n'
          echo "$${knownClientApps[*]}"
        )]"
        echo "New Know Clients [$(
          IFS=$'\n'
          echo "$${newClientApps[*]}"
        )]"

        mergedClientApps=("$${knownClientApps[@]}" "$${newClientApps[@]}") 
        echo "Merged Know Clients [$(
          IFS=$'\n'
          echo "$${mergedClientApps[*]}"
        )]"
        uniqueClientApps=()
        while IFS= read -r -d '' x; do uniqueClientApps+=("$x"); done < <(printf "%s\0" "$${mergedClientApps[@]}" | sort -uz)
        echo "Unique Know Clients [$(
          IFS=$'\n'
          echo "$${uniqueClientApps[*]}"
        )]"

        echo "Remove Existing"
        az ad app update --id $appId --remove knownClientApplications
        echo "Wait"
        sleep 5s
        echo "Adding Merged"
        az ad app update --id $appId --add knownClientApplications $uniqueClientApps

      fi

    EOT
    interpreter = ["/bin/bash"]
  }
  depends_on = [
    azuread_application.backend_apps
  ]
}