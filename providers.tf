terraform {
  backend "azurerm" {}

  required_version = ">= 1.3.7"
  required_providers {
    azurerm = {
      version = "3.42.0"
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
  client_id     = var.B2C_CLIENT_ID
  client_secret = var.B2C_CLIENT_SECRET
  tenant_id     = var.B2C_TENANT_ID
}
