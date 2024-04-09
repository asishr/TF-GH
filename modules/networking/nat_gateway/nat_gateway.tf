resource "azurerm_nat_gateway" "nat_gateway" {
    name                    = var.name
    location                = var.location
    resource_group_name     = var.resource_group_name
    sku_name                = var.sku_name
    idle_timeout_in_minutes = var.idle_timeout_in_minutes
    zones                   = var.zones
    tags                    = var.tags
}

output "id" {
    description = "The ID of this Public IP."
    value       = azurerm_nat_gateway.nat_gateway.id
    # value       = { for k, v in merge(azurerm_nat_gateway.nat_gateway) : k => {
    # "id"       = v.id
    # } }
}

# resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
#   subnet_id      = var.subnet_ids
#   nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
# }