

resource "azurerm_key_vault_certificate" "certificate" {
  for_each     = { for cert in var.certs : cert.name => cert }
  name         = each.value.name
  key_vault_id = var.key_vault_id


  certificate {
    contents = each.value.cert_content
  }

  certificate_policy {
    issuer_parameters {
      name = "self"
    }

    key_properties {
      exportable = true
      key_size   = each.value.key_size
      key_type   = each.value.key_type
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }


  }
  tags = merge(var.tags, each.value.tags)

}