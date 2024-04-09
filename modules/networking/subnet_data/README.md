# Subnet data

This module is a helper module used by other modules, that looks-up information on an existing subnet.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.62.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | the name of the subnet. | `string` | n/a | yes |
| resource_group_name | the name of the name of the reource group to which the subnet is associated. | `string` | n/a | yes |
| virtual_network_name | the name of the virtual network which contains the subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| address_prefixes | a list of address prefixes for the subnet; |
| enforce_private_link_endpoint_network_policies | Disable network policies for the private link endpoint on the subnet are enabled/disabled; |
| enforce_private_link_service_network_policies | network policies for private link service in subnet are enabled/disabled; |
| id | the unique id of the subnet; |
| name | the name of the subnet; |
| network_security_group_id | the unique id of the network security group associated with the sybnet; |
| resource_group_name | the name of the resource group in which the vnet resides; |
| route_table_id | the unique if of the routing table associated with the subnet; |
| service_endpoints | a list of service endpoints within this subnet; |
| virtual_network_name | the name of the virtual network in which the subnet resides; |

<br />

<!-- END_TF_DOCS -->