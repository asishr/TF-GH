output "name" {
  description = "outputs the name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "id" {
  description = "outputs the Azure ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

output "location" {
  description = "outputs the Azure Region where the resource group exists ie. Canada East"
  value       = azurerm_resource_group.resource_group.location
}
