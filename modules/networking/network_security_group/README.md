# Azure - Network Security Rules & Network Security Group Module

This module will create a Network Security Rules, Network Security Group and association with an existing Subnet.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_existing_subnet"></a> [existing\_subnet](#module\_existing\_subnet) | ../existing_subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.network_security_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_existing_subnet"></a> [existing\_subnet](#input\_existing\_subnet) | The lookup parameters for an existing subnet. | `any` | `{}` | no |   
| <a name="input_location"></a> [location](#input\_location) | Azure Region for Network Security Group | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Network Security Group Name | `string` | n/a | yes |
| <a name="input_network_security_rules"></a> [network\_security\_rules](#input\_network\_security\_rules) | Manages a list of Network Security Rules. | `any` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | NSG id |