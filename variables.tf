## Defaults
variable "product" {
  default = "pip"
}
variable "component" {
  default = "sds"
}
variable "location" {
  default = "UK South"
}
variable "env" {}
variable "subscription" {
  default = ""
}
variable "deployment_namespace" {
  default = ""
}
variable "common_tags" {
  type = map(string)
}
variable "team_name" {
  default = "PIP DevOps"
}
variable "team_contact" {
  default = "#vh-devops"
}

## SA Defaults
variable "sa_access_tier" {
  type    = string
  default = "Cool"
}
variable "sa_account_kind" {
  type    = string
  default = "StorageV2"
}
variable "sa_account_tier" {
  type    = string
  default = "Standard"
}
variable "sa_account_replication_type" {
  type    = string
  default = "RAGRS"
}

## KV Details
variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS SDS Developers"
}

## PIP AD Tenant
variable "B2C_TENANT_ID" {
  type        = string
  description = "PIP One Time Password Tenant ID"
  default     = "168c7413-a78f-4297-a21b-72a62c75ad0e"
}
variable "B2C_CLIENT_ID" {
  type        = string
  description = "PIP One Time Password Client ID"
  default     = "fa7ee59a-5c26-4e44-87b0-ffe5a2480346"
}
variable "B2C_CLIENT_SECRET" {
  type        = string
  description = "PIP One Time Password Client Secret"
}
variable "b2c_extension_app_id" {
  type        = string
  description = "PIP B2C Extensions App ID"
}

## Azure Automation
variable "automation_account_sku_name" {
  type        = string
  description = "Azure ad SKU name"
  default     = "Basic"
  validation {
    condition     = contains(["Basic"], var.automation_account_sku_name)
    error_message = "Azure Automation Account SKUs are limited to Basic."
  }
}

## Domain
variable "domain" {
  type        = string
  description = "PIP Domain"
}

variable "apim_kv_mi_access" {
  type        = map(any)
  description = "Map of Managed Identities that should have GET access on APIM Key Vault. name = app_name, value = mi client ID"
  default     = {}
}

# Github
variable "GITHUB_RUNNER_OBJECT_ID" {
  type        = string
  description = "Github Azure App Registration Object ID"
}

# Jenkins
variable "jenkins_mi_client_id" {
  type        = string
  description = "Jenkins Managed Identity Client ID"
}
variable "jenkins_mi_resource_id" {
  type        = string
  description = "Jenkins Managed Identity Resource ID"
}