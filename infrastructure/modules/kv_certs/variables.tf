variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "certs" {
  type = list(object({
    name         = string
    cert_content = string
    key_size     = string
    key_type     = string
    tags         = map(string)
  }))
  description = "Define Azure Key Vault Certificates"
  default     = []
}
