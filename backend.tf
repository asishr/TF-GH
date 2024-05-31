# # terraform {
# #   backend "azurerm" {
# #     resource_group_name   = "rg-terraform-tfstate-cc"
# #     storage_account_name  = "satftfstatebackend"
# #     container_name        = "tfstate"
# #     key                   = "dev.tfstate"
# #   }
# # }

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#     }
#   }


#   backend "azurerm" {
#     resource_group_name   = "rg-terraform-tfstate-cc"
#     storage_account_name  = "satftfstatebackend"
#     container_name        = "tfstate"
#     key                   = "dev.tfstate"
#     use_oidc             = true # To use OIDC to authenticate to the backend
#   }
# }

# provider "azurerm" {
#   features {}
#   use_oidc        = true # Use OIDC to authenticate to Azure
#   subscription_id = "81d07db3-86e1-49db-90a8-994e8228c86d"
# }