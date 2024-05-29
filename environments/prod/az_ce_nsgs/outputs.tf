# the id of the network security group;
# output "nsg_id" {
#   description = "The ID of the newly created Network Security Group"
#   value       = inbound_network_security_group.id
# }

# # the name of the network security group;
# output "nsg_name" {
#   description = "The name of the new NSG"
#   value       = inbound_network_security_group.name
# }

# the unique id of the subnet;
output "subnet_id" {
  value = data.azurerm_subnet.app_subnet.id
}

# the name of the subnet;
output "subnet_name" {
  value = data.azurerm_subnet.app_subnet.name
}

# the name of the resource group in which the vnet resides;
output "resource_group_name" {
  value = data.azurerm_subnet.app_subnet.resource_group_name
}

# the name of the virtual network in which the subnet resides;
output "virtual_network_name" {
  value = data.azurerm_subnet.app_subnet.virtual_network_name
}
