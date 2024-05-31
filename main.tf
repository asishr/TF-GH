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
    client_id            = "293d13af-61f2-415a-a959-dda720544372" # The client ID of the Managed Identity
    subscription_id      = "633c41b2-9e22-4a9c-90fb-299daded47bc" # The subscription ID where the storage account exists
    tenant_id            = "36f13337-06d5-47b6-80f8-7b85cc344f98" # The tenant ID where the subscription and the Managed Identity are
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
