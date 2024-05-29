# ### LOAD BALANCERS ###

# Create the trusted/outbound load balancer.
module "trust_lb" {
  source              = "../modules/networking/loadbalancer"
  for_each            = var.locations
  name                = "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-TRUST-01"
  resource_group_name = module.resource_group_exthub[each.key].name
  location            = each.value.name
  tags                = var.tags
  frontend_ip_configuration = [{
    name                          = "LoadBalancerFrontEnd"
    subnet_id                     = lookup(module.exthub-vnet[each.key].subnet_ids, "SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-TRUST-01", null)
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.ilb_private_ip
  }]
  lb_probe = [{
    name = "LB-Pool-AZ${each.value.alias}${var.environment}EXTPAFW00"
    port = "22"
  }]
  backend_adress_pool =  [{
    name = "AZ${each.value.alias}${var.environment}EXTPAFW01"
  }]
  lb_rules = [{
    name                           = "AZ${each.value.alias}${var.environment}EXTPAF-Private-All-Ports"
    frontend_port                  = 80
    backend_port                   = 80
    protocol                       = "Tcp"
    frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  }]
}

# Create the inbound load balancer's public ips.
module "untrust_lb_public_ip" {
  source                 = "../modules/networking/public_ip"
  for_each               = var.locations
  public_ips = [{
    name                 = "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP"
    location             = each.value.name
    resource_group_name  = module.resource_group_exthub[each.key].name
    virtual_network_name = module.exthub-vnet[each.key].name
    allocation_method    = "Static"
    sku                  = "Standard"
    public_ip_prefix_name = "EXTHUB-UNTRUST-pip-prefix"
    prefix_length        = 24
  }]
}

# Create the inbound/untrusted load balancer.
module "untrust_lb" {
  source              = "../modules/networking/loadbalancer"
  for_each            = var.locations
  name                = "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01"
  resource_group_name = module.resource_group_exthub[each.key].name
  location            = each.value.name
  tags                = var.tags
  frontend_ip_configuration = [{
    name                 = "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP"
    public_ip_address_id = lookup(lookup(module.untrust_lb_public_ip[each.key].public_ip, "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP"), "id")
  }]

  lb_probe = [{
    name = "LB-Pool-AZ${each.value.alias}${var.environment}EXTPAFW00"
    port = "22"
  }]
  backend_adress_pool =  [{
    name = "AZ${each.value.alias}${var.environment}EXTPAFW01"
  }] 
  lb_rules = [
    {
      name                           = "SENTINEL_CEF_TCP_6514"
      frontend_port                  = 6514
      backend_port                   = 6514
      protocol                       = "Tcp"
      frontend_ip_configuration_name = "LB-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP"
      enable_floating_ip             = true
    }
  ]
}