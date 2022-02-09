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

## OTP Subscription
variable "opt_tenant_id" {
  type        = string
  description = "PIP One Time Password Tenant ID"
  default     = "168c7413-a78f-4297-a21b-72a62c75ad0e"
}
variable "otp_client_id" {
  type        = string
  description = "PIP One Time Password Client ID"
  default     = "fa7ee59a-5c26-4e44-87b0-ffe5a2480346"
}
variable "OTP_CLIENT_SECRET" {
  type        = string
  description = "PIP One Time Password Client Secret"
}
variable "otp_app_names" {
  type        = list(string)
  description = "List of Applications in OTP"
  default     = ["PIP-ACCOUNT-MANAGEMENT"]
}

## Azure Automation
variable "automation_account_sku_name" {
  type        = string
  description = "Azure B2C SKU name"
  default     = "Basic"
  validation {
    condition     = contains(["Basic"], var.automation_account_sku_name)
    error_message = "Azure Automation Account SKUs are limited to Basic."
  }
}