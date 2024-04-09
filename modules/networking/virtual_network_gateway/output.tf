output "id" {
  description = "Virtual network id."
  value       = azurerm_virtual_network_gateway.virtual_network_gateway.id
}

output "bgp_settings" {
  description = "bgp_settings "
  value       = azurerm_virtual_network_gateway.virtual_network_gateway.bgp_settings
}
