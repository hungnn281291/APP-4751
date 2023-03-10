terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }

    azapi = {
      source = "Azure/azapi"
    }

  }
}

provider "azurerm" {
  features {}
  use_msi                    = true # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity
  skip_provider_registration = true # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#skip_provider_registration
  storage_use_azuread        = true # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#storage_use_azuread
}

provider "azurerm" {
  alias           = "secondary"
  subscription_id = var.SUBSCRIPTION_ID_SECONDARY
  features {}
}

provider "azapi" {

}