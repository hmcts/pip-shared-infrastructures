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

## Secrets
variable "secrets_arr" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Key Vault Secrets from AzDO Library"
  #sensitive   = true
  default = []
}

## OTP Subscription
variable "opt_tenant_id" {
  type        = string
  description = "PIP One Time Password Tenant ID"
}
variable "otp_client_id" {
  type        = string
  description = "PIP One Time Password Client ID"
}
variable "otp_client_secret" {
  type        = string
  description = "PIP One Time Password Client Secret"
}
variable "otp_app_names" {
  type        = list(string)
  description = "List of Applications in OTP"
  default     = ["PIP-ACCOUNT-MANAGEMENT"]
}
