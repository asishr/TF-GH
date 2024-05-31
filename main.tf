terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name   = "rg-terraform-tfstate-cc"
    storage_account_name  = "satftfstatebackend"
    container_name        = "tfstate"
    key                   = "dev.tfstate"
    use_oidc             = true # To use OIDC to authenticate to the backend
  }
}

provider "azurerm" {
  features {}
  use_oidc        = true # Use OIDC to authenticate to Azure
  subscription_id = "633c41b2-9e22-4a9c-90fb-299daded47bc"
}

module "resource_group" {
  source   = "./modules/common/resource_group"
  name     = "tf-gh-sample-rg2"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}
