terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
    null = {
      source = "hashicorp/null"
    }
    tfe = {
      version = "~> 0.42.0"
    }    
  }
  required_version = ">= 0.15"
}

