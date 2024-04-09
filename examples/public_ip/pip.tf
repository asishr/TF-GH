provider "azurerm" {
  features {}
}

module "resource_group" {
  source                = "../../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-INTHUB-01"
  location              = each.value.name
  tags                  = var.tags
}

module "public_ip" { ## Will be replaced by ER
  source              = "../../modules/networking/public_ip"
  for_each            = var.locations
  public_ips = [{
    name                = "GW-${each.value.alias}-EXTHUB-TRUST-01-PIP"
    resource_group_name = module.resource_group[each.key].name
    location            = each.value.name
    allocation_method   = "Static"
    sku                 = "Standard"
    nat_gateway_id      = module.nat_gateway[each.key].id #lookup(lookup(module.nat_gateway[each.key].nat_gateway, "nat-gateway"), "id")
    public_ip_prefix_name = "pip-prefix"
  }]
}

module "nat_gateway" {
  source              = "../../modules/networking/nat_gateway"
  for_each            = var.locations
  name                = "nat-gateway"
  location            = module.resource_group[each.key].location
  resource_group_name = module.resource_group[each.key].name
  # sku_name                = "Standard"
  # idle_timeout_in_minutes = 10
  # zones                   = ["1"]
  # public_ip_prefix_id = azurerm_public_ip_prefix.public_ip_prefix[each.key].id
  # subnet_ids          = [""]
}