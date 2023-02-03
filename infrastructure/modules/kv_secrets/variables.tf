variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "expiration_date" {
  description = "Expiration date for a secret"
  type        = string
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  type = list(object({
    name         = string
    value        = string
    tags         = map(string)
    content_type = string
  }))
  description = "Define Azure Key Vault secrets"
  default     = []
}
