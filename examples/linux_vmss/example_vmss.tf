provider "azurerm" {
  features {}
}

module "random_password" {
  source           = "../../modules/common/password_generator"
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "linux-vmss-rg"
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
  }]
}

locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}
# Create the a vmss scale set.
module "vmss_scale_set" {
  source = "../../modules/compute/linux_vmss"
  name                = "VM-Infra-dev"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  admin_username      = "adminuser"
  admin_password      = module.random_password.password
  public_key          = local.first_public_key

  source_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk = {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface = [{
    name    = "example-nic1"
    primary = true
    enable_ip_forwarding          = true
    enable_accelerated_networking = false

    ip_configuration = [{
      name      = "internal1"
      primary   = true
      subnet_id = module.virtual_network.subnet["subnet1"].id

      public_ip_address = [{
        name                    = "nic-pip1"
        idle_timeout_in_minutes = 4
      }]
    }]
  },{
    name    = "example-nic2"
    primary = true
    enable_ip_forwarding          = true
    enable_accelerated_networking = false

    ip_configuration = [{
      name      = "internal2"
      primary   = true
      subnet_id = module.virtual_network.subnet["subnet1"].id

      public_ip_address = [{
        name                    = "nic-pip2"
        idle_timeout_in_minutes = 4
      }]
    }]
  }]
}
