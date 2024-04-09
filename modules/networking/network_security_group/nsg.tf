resource "azurerm_network_security_group" "network_security_group" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "network_security_rule" {
    for_each                    = { for rule in var.network_security_rules : rule.name => rule }
    name                        = each.value.name
    priority                    = each.value.priority
    direction                   = each.value.direction
    access                      = each.value.access
    protocol                    = each.value.protocol
    source_port_range           = each.value.source_port_range
    destination_port_range      = each.value.destination_port_range
    source_address_prefix       = each.value.source_address_prefix
    destination_address_prefix  = each.value.destination_address_prefix
    resource_group_name         = lookup(each.value, "resource_group_name", var.resource_group_name)
    network_security_group_name = azurerm_network_security_group.network_security_group.name
}

module "subnet_data" {
    source               = "../subnet_data"
    count                = length(var.subnet_data) > 0 ? 1 : 0
    name                 = lookup(var.subnet_data, "subnet_name", null)
    virtual_network_name = lookup(var.subnet_data, "virtual_network_name", null)
    resource_group_name  = lookup(var.subnet_data, "resource_group_name", var.resource_group_name)
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association" {
    count                     = length(var.subnet_data) > 0 || var.subnet_id != null ? 1 : 0
    subnet_id                 = var.subnet_id != null ? var.subnet_id : module.subnet_data[0].id
    network_security_group_id = azurerm_network_security_group.network_security_group.id
}