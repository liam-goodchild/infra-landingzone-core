terraform {
  required_version = ">= 1.0, < 2.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0, < 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.2, < 3.0"
    }
    alz = {
      source  = "azure/alz"
      version = ">= 0.17, < 1.0"
    }
  }
}
