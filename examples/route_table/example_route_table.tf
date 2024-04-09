provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "nsg-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}

module "route_table" {
  source              = "../../modules/networking/route_table"
  name                = "ar-route-tables"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  routes = [{ 
    name                = "TestRoute1"
    address_prefix      = "10.1.0.0/16"
    next_hop_type       = "VnetLocal"
  },{ 
    name                = "TestRoute2"
    address_prefix      = "10.2.0.0/16"
    next_hop_type       = "VnetLocal"
  },{ 
    name                = "TestRoute3"
    address_prefix      = "10.3.0.0/16"
    next_hop_type       = "VnetLocal"
  }]
}
