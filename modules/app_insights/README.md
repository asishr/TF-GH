<!-- BEGIN_TF_DOCS -->
# Azure Application Insights Module

This terraform module creates Application Insights instance in Azure.

## Assumptions
* An Azure virtual network, subnets, and security groups exist

# Examples
## All Attributes
`terraform apply`

app-insights.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "app_insights" {
  source                                              = "../../../modules/app_insights"
  appinsights_name                                    = "appinsights_web"
  location                                            = "canadacentral"
  resource_group_name                                 = "LOGS-RG"
  application_type                                    = "web"
  daily_data_cap_in_gb                                = 100
  daily_data_cap_notifications_disabled               = false
  retention_in_days                                   = 180
  sampling_percentage                                 = 50
  disable_ip_masking                                  = true
  tags = {
    ProjectName                                       = "demo-internal"
    Env                                               = "dev"
    Owner                                             = "user@example.com"
    BusinessUnit                                      = "CORP"
    ServiceClass = "Gold"
  }
}
```

# Resources Created
This modules creates:
* 1 Application Insights 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.appinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appinsights_name"></a> [appinsights\_name](#input\_appinsights\_name) | Application Insights name | `string` | n/a | yes |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | (Required) Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. | `string` | `"other"` | no |
| <a name="input_daily_data_cap_in_gb"></a> [daily\_data\_cap\_in\_gb](#input\_daily\_data\_cap\_in\_gb) | (Optional) Specifies the Application Insights component daily data volume cap in GB. | `number` | `null` | no |
| <a name="input_daily_data_cap_notifications_disabled"></a> [daily\_data\_cap\_notifications\_disabled](#input\_daily\_data\_cap\_notifications\_disabled) | (Optional) Specifies if a notification email will be send when the daily data volume cap is met. (set to false to enable) | `bool` | `true` | no |
| <a name="input_disable_ip_masking"></a> [disable\_ip\_masking](#input\_disable\_ip\_masking) | (Optional) By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip. Defaults to false. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group where to create the resource. | `any` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90. | `number` | `90` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | (Optional) Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key/value pairs of tags that will be applied to all resources in this module. | `map(string)` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Log Analytics Workspace based workspace id | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | The App ID associated with this Application Insights component. |
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string) | The Connection String for this Application Insights component. (Sensitive) |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Application Insights component. |
| <a name="output_instrumentation_key"></a> [instrumentation\_key](#output\_instrumentation\_key) | The Instrumentation Key for this Application Insights component. (Sensitive) |

# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Application Insights: https://docs.microsoft.com/en-us/azure/azure-monitor/
* Azure Application Insights Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
* Azure Security Group Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
* Azure Subnet Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

<!-- END_TF_DOCS -->