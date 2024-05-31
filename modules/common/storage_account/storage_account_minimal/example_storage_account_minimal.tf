provider "azurerm" {
  features {}
}

provider "azuread" {
}


module "environment_variables" {
  source           = "../../../../tools/environment_variables/v1"
  environment      = "dev"
  cost_center      = "1234"
  application_name = ""
}

module "example_rg" {
  source   = "../../../../common/resource_group/v1"
  name     = "example-rgn"
  location = "Canada Central"
}

module "example_storage" {
  source                   = "../../../../storage/storage_account/v1"
  name                     = "examplestorageacnt"
  resource_group_name      = module.example_rg.name
  location                 = "Canada Central"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules = {
    core_services = ["CanadianJenkins"]
  }
}
