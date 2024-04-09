# # Terraform supermodule for the CAF Terraform landing zones part of Microsoft Cloud Adoption Framework for Azure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      //version = "~> 3.0.0"
    }
  }
}

