resource "azurerm_public_ip" "public_ip" {
    for_each            = { for ip in var.public_ips : ip.name => ip }
    name                = each.value.name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name
    allocation_method   = each.value.allocation_method
    sku                 = each.value.sku
    zones               = lookup(each.value, "zones", null)
    domain_name_label   = lookup(each.value, "domain_name_label", null)
    edge_zone           = lookup(each.value, "edge_zone", null)
    ip_tags             = lookup(each.value, "ip_tags", null)
    ip_version          = lookup(each.value, "ip_version", null)
    public_ip_prefix_id = lookup(each.value, "public_ip_prefix_id", null)
    reverse_fqdn        = lookup(each.value, "reverse_fqdn", null)
    sku_tier            = lookup(each.value, "sku_tier", null)
    tags                = lookup(each.value, "tags", null)
    idle_timeout_in_minutes = lookup(each.value, "idle_timeout_in_minutes", null)
}

resource "azurerm_public_ip_prefix" "public_ip_prefix" {
    for_each             = { for ip in var.public_ips : ip.name => ip }
    name                 = each.value.public_ip_prefix_name
    location             = each.value.location
    resource_group_name  = each.value.resource_group_name
    prefix_length        = lookup(each.value, "prefix_length", null)
    zones                = lookup(each.value, "zones", [])
    sku                  = lookup(each.value, "sku", null)
    ip_version           = lookup(each.value, "ip_version", null)
}

locals {
    pip_with_nat_gateway = {
        for pip in var.public_ips :
        pip.name => pip.nat_gateway_id
        if pip.nat_gateway_id != null
    }
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip" {
    for_each = local.pip_with_nat_gateway 
    nat_gateway_id       = each.value
    public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "public_ip_prefix_association" {
    for_each = local.pip_with_nat_gateway
    nat_gateway_id      = each.value
    public_ip_prefix_id = azurerm_public_ip_prefix.public_ip_prefix[each.key].id
}