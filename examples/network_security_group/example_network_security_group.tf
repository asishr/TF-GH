provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "nsg-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}

module "network_security_group" {
  source              = "../../modules/networking/network_security_group"
  name                = "ar-nsgs"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  # subnet_id = ""
  # subnet_data = { ## If specified NSG will be associated to the Subnet ##
  #   virtual_network_name = "VNET-CAC-NonProduction"
  #   subnet_name          = "PaaS01"
  #   resource_group_name  = "CAC-NonProduction-network"
  # }

  network_security_rules = [{ 
    name                        = "test123"
    priority                    = 100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  },{ 
    name                        = "test234"
    priority                    = 200
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  },{ 
    name                        = "test456"
    priority                    = 300
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }]
}
