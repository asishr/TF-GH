provider "azurerm" {
  features {}
}

module "resource_group" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-01"
  location              = each.value.name
  tags                  = var.tags
}

module "trust_lb" {
  source              = "../modules/networking/loadbalancer"
  for_each            = var.locations
  name                = "LB-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-TRUST-01"
  resource_group_name = module.resource_group[each.key].name
  location            = each.value.name
  tags                = var.tags
  frontend_ip_configuration = [{
    name                          = "LoadBalancerFrontEnd"
    subnet_id                     = lookup(module.vnet[each.key].subnet_ids, "SNET-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-TRUST-01", null) 
    private_ip_address_allocation = "Dynamic" #"Static"
    private_ip_address            = var.trust_lb_private_ip
  }]
  lb_probe = [{
    name = "LB-Probe-PAN"
    port = "22"
    protocol = "Tcp"
    interval_in_seconds = 5
  }]

  backend_adress_pool = [{
    name = "AZ${each.value.alias}${var.environment}INTPAFW00"
  }]

  lb_rules = [{
    name                           = "AZ${each.value.alias}${var.environment}INTPAFW00"
    frontend_port                  = 80
    backend_port                   = 80
    protocol                       = "Tcp"
    frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  }]
}
