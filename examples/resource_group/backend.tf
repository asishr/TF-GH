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
    use_oidc              = true # To use OIDC to authenticate to the backend
    tenant_id = "36f13337-06d5-47b6-80f8-7b85cc344f98"
    client_id = "96844b22-b284-4ab9-b112-6d340b9db420"
  }
}

provider "azurerm" {
  features {}
  use_oidc        = true # Use OIDC to authenticate to Azure
  subscription_id = "633c41b2-9e22-4a9c-90fb-299daded47bc"
  # tenant_id = "36f13337-06d5-47b6-80f8-7b85cc344f98"
  # client_id = "96844b22-b284-4ab9-b112-6d340b9db420"
}