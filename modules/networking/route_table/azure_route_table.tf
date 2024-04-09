resource "azurerm_route_table" "route_table" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    disable_bgp_route_propagation = var.disable_bgp_route_propagation
    tags                = var.tags
}

resource "azurerm_route" "route" {
    for_each                    = { for route in var.routes : route.name => route }
    name                        = each.value.name
    route_table_name            = lookup(each.value, "route_table_name", var.name)
    resource_group_name         = lookup(each.value, "resource_group_name", var.resource_group_name)
    address_prefix              = each.value.address_prefix
    next_hop_type               = each.value.next_hop_type
    next_hop_in_ip_address      = lookup(each.value, "next_hop_in_ip_address", null)
}

module "subnet_data" {
    source               = "../subnet_data"
    count                = length(var.subnet_data) > 0 ? 1 : 0
    name                 = lookup(var.subnet_data, "subnet_name", null)
    virtual_network_name = lookup(var.subnet_data, "virtual_network_name", null)
    resource_group_name  = lookup(var.subnet_data, "resource_group_name", var.resource_group_name)
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
    count                = length(var.subnet_data) > 0 ? 1 : 0
    subnet_id            = module.subnet_data[0].id
    route_table_id       = [for rt in azurerm_route.route : rt.id]
}