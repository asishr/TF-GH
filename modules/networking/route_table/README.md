# Azure - Route Table & Routes Module

This module will create a Routes, Route Table and association with an existing Subnet.

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| <a name="input_location"></a> [location](#input\_location) | Azure Region for Route Table | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Route Table Name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Manages a list of Routes. | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | An override to specify tags which will be added to the Route Table. | `map(string)` | `{}` | no |        

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Route id |

<!--- END_TF_DOCS --->
