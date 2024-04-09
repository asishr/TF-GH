# Azure - Firewall

Manages an Azure Firewall.

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution. | `any` | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional) The ID of the Firewall Policy applied to this Firewall. | `string` | `null` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | (Optional) An ip\_configuration block | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
ltering. Possible values are: Off, Alert and Deny. Defaults to Alert. | `string` | `null` | no || <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | (Optional) A virtual\_hub block | `map(string)` | `{}` | no || <a name="input_zones"></a> [zones](#input\_zones) | (Optional) Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created. | `list(string)` | `[]` | no |

## Outputs
| Name | Description |
|------|-------------|| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | Fully qualified domain name of the A DNS record associated with the public IP. domain\_name\_label must be specified to get the fqdn. This is the concatenation of the domain\_name\_label and the regionalized DNS zone || <a name="output_id"></a> [id](#output\_id) | The ID of this Public IP. |
| <a name="output_ip_configuration"></a> [ip\_configuration](#output\_ip\_configuration) | The IP address value that was allocated. |

<!--- END_TF_DOCS --->
