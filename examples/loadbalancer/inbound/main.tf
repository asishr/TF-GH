provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB"
  location            = "Canada Central"
  resource_group_name = "IGM-MGMT-Dev-RG"
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "inbound_lb" {
  source              = "../../../modules/networking/loadbalancer"

  resource_group_name = "IGM-MGMT-Dev-RG"
  location            = "Canada Central"
  name                = "public-lb-example"

  frontend_ip_configuration = [{
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }]

  backend_adress_pool = [{
    name = "AZINTPAFW00"
  }]
  lb_probe = [{
    name = "LB-Probe-PAN"
    port = "22"
    protocol = "Tcp"
    interval_in_seconds = 5
  },{
    name = "LB-Probe-PAN2"
    port = "22"
    protocol = "Tcp"
    interval_in_seconds = 5
  }]
  lb_rules = [{
    name                           = "LB-Probe-PAN"
    frontend_port                  = 80
    backend_port                   = 80
    protocol                       = "Tcp"
    frontend_ip_configuration_name = "PublicIPAddress"
    probe_name = "LB-Probe-PAN"
  },{
    name                           = "LB-Probe-PAN2"
    frontend_port                  = 22
    backend_port                   = 22
    protocol                       = "Tcp"
    frontend_ip_configuration_name = "PublicIPAddress"
    probe_name = "LB-Probe-PAN2"
  }]
}