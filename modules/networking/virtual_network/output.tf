output "name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.vnet.name
}

output "id" {
  description = "Virtual network id."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet" {
  description = "Subnet id."
  value       = merge(azurerm_subnet.subnet)
}

output "subnet_ids" {
  description = "The identifiers of the created Subnets."
  value = {
    for k, v in azurerm_subnet.subnet : k => v.id
  }
}

output "subnet_name" {
  description = "The identifiers of the created Subnets."
  value = {
    for k, v in azurerm_subnet.subnet : k => v.name
  }
}


