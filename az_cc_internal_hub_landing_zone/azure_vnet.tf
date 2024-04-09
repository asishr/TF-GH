module "vnet_resource_group" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-VN"
  location              = each.value.name
  tags                  = var.tags
}

module "vnet" {
  source              = "../modules/networking/virtual_network"
  for_each            = var.locations
  name                = "VN-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-01"
  resource_group_name = module.vnet_resource_group[each.key].name
  location            = each.value.name
  address_space       = each.value.address_space
  subnets             = each.value.subnets
  tags                = var.tags
}

module "public_ip" { ## Will be replaced by ER
  source              = "../modules/networking/public_ip"
  for_each            = var.locations
  public_ips = [{
    name                = "GW-${each.value.alias}-${var.bu}-${var.environment}-EXTHUB-TRUST-01-PIP"
    resource_group_name = module.vnet_resource_group[each.key].name
    location            = each.value.name
    allocation_method   = "Static"
    sku                 = "Standard"
  }]
}

module "virtual_network_gateway" {
  source   = "../modules/networking/virtual_network_gateway"
  for_each            = var.locations
  name                = "GW-${each.value.alias}-${var.bu}-${var.environment}-EXTHUB-TRUST-01"
  resource_group_name = module.vnet_resource_group[each.key].name
  location            = each.value.name

  type     = "ExpressRoute"

  active_active = false
  enable_bgp    = false
  sku           = "Standard"

  ip_configuration = {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = lookup(lookup(module.public_ip[each.key].public_ip, "GW-${each.value.alias}-${var.bu}-${var.environment}-EXTHUB-TRUST-01-PIP"), "id")
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = lookup(module.vnet[each.key].subnet_ids, "GatewaySubnet", null)
  }
  depends_on = [
    module.trust_lb
  ]
}

module "route_table" {
  source              = "../modules/networking/route_table"
  for_each            = var.locations
  name                = "RT-${each.value.alias}-${var.bu}-${var.environment}-DEFAULT-01"
  resource_group_name = module.resource_group[each.key].name
  location            = each.value.name
  # subnet_id           = lookup(module.vnet[each.key].subnet_ids, "SNET-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-MGMT-01", null)

  routes = [{ 
    name                = "Azure-${each.value.alias}-Internal"
    address_prefix      = "10.0.0.0/8"
    next_hop_type       = "None"
    next_hop_in_ip_address = var.trust_lb_private_ip #"LB-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-TRUST-01"
  # },{ 
  #   name                = "Azure-${each.value.alias}-External"
  #   address_prefix      = "0.0.0.0/0"
  #   next_hop_type       = "None"
  #   next_hop_in_ip_address = "LB-${each.value.alias}-${var.bu}-${var.environment}-EXTHUB-TRUST-01"
  }]
  depends_on = [
    module.vnet
  ]
}