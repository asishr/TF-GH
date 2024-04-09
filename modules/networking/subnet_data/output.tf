# Module outputs;

# the unique id of the subnet;
output "id" {
  value = data.azurerm_subnet.existing_subnet.id
}

# the name of the subnet;
output "name" {
  value = data.azurerm_subnet.existing_subnet.name
}

# the name of the resource group in which the vnet resides;
output "resource_group_name" {
  value = data.azurerm_subnet.existing_subnet.resource_group_name
}

# the name of the virtual network in which the subnet resides;
output "virtual_network_name" {
  value = data.azurerm_subnet.existing_subnet.virtual_network_name
}

# a list of address prefixes for the subnet;
output "address_prefixes" {
  value = data.azurerm_subnet.existing_subnet.address_prefixes
}

# Additional outputs from data source;

# Disable network policies for the private link endpoint on the subnet are enabled/disabled;
output "enforce_private_link_endpoint_network_policies" {
  value = data.azurerm_subnet.existing_subnet.enforce_private_link_endpoint_network_policies
}

# network policies for private link service in subnet are enabled/disabled;
output "enforce_private_link_service_network_policies" {
  value = data.azurerm_subnet.existing_subnet.enforce_private_link_service_network_policies
}

# the unique id of the network security group associated with the sybnet;
output "network_security_group_id" {
  value = data.azurerm_subnet.existing_subnet.network_security_group_id
}

# the unique if of the routing table associated with the subnet;
output "route_table_id" {
  value = data.azurerm_subnet.existing_subnet.route_table_id
}

# a list of service endpoints within this subnet;
output "service_endpoints" {
  value = data.azurerm_subnet.existing_subnet.service_endpoints
}
