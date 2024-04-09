
provider "azurerm" {
  features {}
}

module "outbound_lb" {
  source              = "../../../modules/networking/loadbalancer"
  
  resource_group_name = "IGM-MGMT-Dev-RG"
  location            = "Canada Central"
  name                = "lb-outbound-example"
  probe_name          = "lb-outbound-probe"
  backend_name        = "lb-outbound-backend"
  frontend_ips = {
    internal_fe = {
      subnet_id                     = ""
      private_ip_address_allocation = "Static" // Dynamic or Static
      private_ip_address            = "10.0.1.6" 
      rules = {
        HA_PORTS = {
          port         = 0
          protocol     = "All"
        }
      }
    }
  }
}