# Azure - Firewall Module

A Terraform module for deploying a Azure Firewall Policy and Firewall Policy Rule Collection Group. The module creates a multiple firewall rules and multiple firewall rule collections group.

## Assumptions
* An Azure virtual network, subnets, azure firewall, public ip and resource group exist

# Examples
`terraform apply`

## Deploy the firewall policy with policy rule collections group
module "firewall_policy" {
  source              = "../../modules/networking/firewall_policy"
  name                = "testfirewall-policy"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  rule_collection_group = [{
    name               = "example-fwpolicy-rcg"
    priority           = 500

    network_rule_collection = [{
      name     = "network_rule_collection1"
      priority = 400
      action   = "Deny"
      rule = [{
        name                  = "network_rule_collection1_rule1"
        protocols             = ["TCP", "UDP"]
        source_addresses      = ["10.0.0.1"]
        destination_addresses = ["192.168.1.1", "192.168.1.2"]
        destination_ports     = ["80", "1000-2000"]
      }]
    }]

    nat_rule_collection = [{
      name     = "nat_rule_collection1"
      priority = 300
      action   = "Dnat"
      rule = [{
        name                = "nat_rule_collection1_rule1"
        protocols           = ["TCP", "UDP"]
        source_addresses    = ["10.0.0.1", "10.0.0.2"]
        destination_address = "192.168.1.1"
        destination_ports   = ["80"]
        translated_address  = "192.168.0.1"
        translated_port     = "8080"
      }]
    }]

    application_rule_collection = [{
      name     = "app_rule_collection1"
      priority = 500
      action   = "Deny"
      rule =[{
        name = "app_rule_collection1_rule1"
        protocols = {
          type = "Http"
          port = 80
        }
        protocols = {
          type = "Https"
          port = 443
        }
        source_addresses  = ["10.0.0.1"]
        destination_fqdns = ["*.microsoft.com"]
      }]
    }]
  }]
}

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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.firewall_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_rule_collection"></a> [application\_rule\_collection](#input\_application\_rule\_collection) | (Optional) One or more application\_rule\_collection blocks. | `any` | `[]` | no |
| <a name="input_base_policy_id"></a> [base\_policy\_id](#input\_base\_policy\_id) | (Optional) The ID of the base Firewall Policy. | `string` | `null` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | (Optional) A dns block | `map(string)` | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block | `map(string)` | `{}` | no |
| <a name="input_insights"></a> [insights](#input\_insights) | (Optional) An insights block | `map(string)` | `{}` | no |
| <a name="input_intrusion_detection"></a> [intrusion\_detection](#input\_intrusion\_detection) | (Optional) A intrusion\_detection block | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Firewall Policy should exist. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Firewall Policy | `string` | n/a | yes |
| <a name="input_nat_rule_collection"></a> [nat\_rule\_collection](#input\_nat\_rule\_collection) | (Optional) One or more firewall policy nat rule collection blocks. | `any` | `[]` | no |
| <a name="input_network_rule_collection"></a> [network\_rule\_collection](#input\_network\_rule\_collection) | (Optional) One or more firewall policy rule collection blocks. | `any` | `[]` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | (Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000. | `number` | `null` | no |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | (Optional) A list of private IP ranges to which traffic will not be SNAT. | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where the Firewall Policy should exist. | `string` | n/a | yes |
| <a name="input_rule_collection_group"></a> [rule\_collection\_group](#input\_rule\_collection\_group) | (Required) The name which should be used for this Firewall Policy Rule Collection Group. | `any` | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium and Basic. | `string` | `null` | no |
| <a name="input_sql_redirect_allowed"></a> [sql\_redirect\_allowed](#input\_sql\_redirect\_allowed) | (Optional) Whether SQL Redirect traffic filtering is allowed. Enabling this flag requires no rule using ports between 11000-11999. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_threat_intelligence_allowlist"></a> [threat\_intelligence\_allowlist](#input\_threat\_intelligence\_allowlist) | (Optional) A threat\_intelligence\_allowlist block | `map(string)` | `{}` | no |
| <a name="input_threat_intelligence_mode"></a> [threat\_intelligence\_mode](#input\_threat\_intelligence\_mode) | (Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert. | `string` | `null` | no |
| <a name="input_tls_certificate"></a> [tls\_certificate](#input\_tls\_certificate) | (Optional) A tls\_certificate block | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_child_policies"></a> [child\_policies](#output\_child\_policies) | A list of reference to child Firewall Policies of this Firewall Policy. |
| <a name="output_firewalls"></a> [firewalls](#output\_firewalls) | A list of references to Azure Firewalls that this Firewall Policy is associated with. |
| <a name="output_id"></a> [id](#output\_id) | The ID of this Public IP. |
| <a name="output_rule_collection_groups"></a> [rule\_collection\_groups](#output\_rule\_collection\_groups) | A list of references to Firewall Policy Rule Collection Groups that belongs to this Firewall Policy. |
<!-- END_TF_DOCS -->