terraform {
  backend "azurerm" {}

  required_version = ">= 1.0.4"
  required_providers {
    azurerm = {
      version = ">=2.0.0"
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
  alias         = "b2c_sub"
  client_id     = var.b2c_client_id
  client_secret = var.b2c_CLIENT_SECRET
  tenant_id     = var.b2c_tenant_id
}
