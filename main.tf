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

  subscription_id = "836b8cd3-0110-4622-a835-5571ddc176e5"
  client_id       = "a1c900d9-3ee6-4331-80bb-46df32fa6c2c"
  client_secret   = "Ldu8Q~mdINgrLp7pOqv6GEjzgY9ftD70jYw0KaBL"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "TF-GH-RG"
  location = "West Europe"
}