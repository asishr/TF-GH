terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "d674c517-8ec5-4b7d-b4fd-71f62f72f0fb"
  client_id       = "9c699268-0e50-4f69-9703-cd7782b11534"
  client_secret   = "BwF8Q~R6mk5eL-dy7pDQFf~rIWKxTVQau9ieDa-W"
  tenant_id       = "dc411c63-1f52-4491-bb51-c4d215a1de23"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "TF-GH-RG"
  location = "West Europe"
}