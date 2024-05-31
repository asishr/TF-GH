# terraform {
#   backend "azurerm" {
#     resource_group_name   = "rg-terraform-tfstate-cc"
#     storage_account_name  = "satftfstatebackend"
#     container_name        = "tfstate"
#     key                   = "dev.tfstate"
#   }
# }

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
    # client_id            = "293d13af-61f2-415a-a959-dda720544372" # The client ID of the Managed Identity
    # subscription_id      = "d674c517-8ec5-4b7d-b4fd-71f62f72f0fb" # The subscription ID where the storage account exists
    # tenant_id            = "dc411c63-1f52-4491-bb51-c4d215a1de23" # The tenant ID where the subscription and the Managed Identity are
  }
}

provider "azurerm" {
  features {}
  use_oidc        = true # Use OIDC to authenticate to Azure
  subscription_id = "81d07db3-86e1-49db-90a8-994e8228c86d"
}