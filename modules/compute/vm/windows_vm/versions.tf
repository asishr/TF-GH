terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 0.15"
}