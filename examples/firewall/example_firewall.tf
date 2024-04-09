provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "nsg-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}

module "virtual_network" {
  source   = "../../modules/networking/virtual_network"
  name                = "vnet-rg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnets = [{
    name                 = "subnet1"
    address_prefixes     = ["10.0.1.0/24"]

    delegation = {
      name = "delegation1"

      service_delegation  = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
    }
  }]
}

module "public_ip" {
  source              = "../../modules/networking/public_ip"
  public_ips = [{
    name                = "testpip1"
    location            = module.resource_group.location
    resource_group_name = module.resource_group.name
    allocation_method   = "Static"
    sku                 = "Standard"
  },{
    name                = "testpip2"
    location            = module.resource_group.location
    resource_group_name = module.resource_group.name
    allocation_method   = "Static"
    sku                 = "Standard"
  }]
}

module "firewall" {
  source              = "../../modules/networking/firewall"
  name                = "testfirewall"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ip_configuration = {
    name                 = "configuration"
    subnet_id            = module.virtual_network.subnet["subnet1"].id
    public_ip_address_id = lookup(lookup(module.public_ip.public_ip, "testpip1"), "id")
  }
}