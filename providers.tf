terraform {
  backend "azurerm" {}

  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.96.0"
    }
    random = {
      version = ">= 2.2.0"
    }
    azuread = {
      version = ">=1.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "random" {}
provider "azuread" {}
provider "azuread" {
  alias         = "aad_sub"
  client_id     = var.ad_client_id
  client_secret = var.AD_CLIENT_SECRET
  tenant_id     = var.ad_tenant_id
}
provider "azuread" {
  alias         = "b2c_sub"
  client_id     = var.ad_client_id
  client_secret = var.AD_CLIENT_SECRET
  tenant_id     = var.ad_tenant_id
}
