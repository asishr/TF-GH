terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-tfstate-cc"
    storage_account_name  = "satftfstatebackend"
    container_name        = "tfstate"
    key                   = "dev.tfstate"
  }
}