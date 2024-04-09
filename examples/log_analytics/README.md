# Azure Data Lake Module

This terraform module creates Log Analytics Workspace instance in Azure.

## Assumptions
* An Azure virtual network, subnets, and security groups exist

# Examples
## Log Analytics Workspace instance with azurerm monitor private link scope and service
`terraform apply`

main.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "log_analytics" {
    source   = "../../modules/log_analytics"
    law_name                              = "lawtest"
    location                              = "canadacentral"
    resource_group_name                   = "IGM-MGMT-Dev-RG"
    create_new_workspace                  = true
    law_sku                               = "PerNode"
    retention_in_days                     = "30"
    daily_quota_gb                        = "0.5"
    internet_ingestion_enabled            = false
    internet_query_enabled                = false
    ampls_name                            = "exampleampls"
    ampls_link_name                       = "example-privatelink"
    tags = {
      businessUnit                          = "HR"
      environment                           = "Production"
      costcenter                            = "123456"
    }
}

```

# Resources Created
This modules creates:
* 1 Azure Log Analytics Workspace
* 2 Azure Monitor Private Link Scope
* 3 Azure Monitor Private Link Scoped Service

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 2.60.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.60.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | Location in which Azure Log Analytics Workspace instance will be deployed | `string` | n/a | yes |
| resource\_group\_name | Name of resource group into which Azure Log Analytics Workspace instance will be deployed | `string` | n/a | yes |
| law\_name | Azure Log Analytics Workspace Name | `string` | n/a | yes |
| ampls\_name | The name of the Azure Monitor Private Link Scope | `string` | n/a | yes |
| ampls\_link\_name | Specifies the name of this Private Link Service | `string` | n/a | yes |
| create\_new\_workspace | Whether or not you wish to create a new workspace, if set to true, a new one will be created, if set to false, a data read will be performed on a data source | `bool` | `true` | yes |
| daily\_quota\_gb | The amount of gb set for max daily ingetion | `string` | `null` | no |
| internet\_ingestion\_enabled | Whether internet ingestion is enabled | `bool` | `false` | yes |
| internet\_query\_enabled | Whether or not your workspace can be queried from the internet | `bool` | `false` | yes |
| law\_sku | The sku of the log analytics workspace | `string` | `null` | no |
| reservation\_capacity\_in\_gb\_per\_day | The reservation capacity gb per day, can only be used with CapacityReservation SKU | `string` | `null` | no |
| retention\_in\_days | The number of days for retention, between 7 and 730 | `number` | `0` | no |
| tags | A map of the tags to use on the resources that are deployed with this module | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| law_id | The  id of the log analytics workspace. If a new log analytic workspace is created, fetch its data id, if one is created, fetch the remote one instead |
| law_name | The name of the log analytics workspace |
| law_primary_key | The primary key of the log analytics workspace. If a new log analytic workspace is created, fetch its data id, if one is created, fetch the remote one instead |
| law_secondary_key | The primary key of the log analytics workspace. If a new log analytic workspace is created, fetch its data id, if one is created, fetch the remote one instead |
| law_workspace_id | The workspace id of the log analytics workspace. If a new log analytic workspace is created, fetch its data id, if one is created, fetch the remote one instead |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Log Analytics Workspace: https://docs.microsoft.com/en-us/azure/azure-monitor/
* Azure Log Analytics Workspace Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace
* Azure Monitor Private Link Scope Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scope
* Azure Monitor Private Link Scopeed Service Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_private_link_scoped_service
* Azure Security Group Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
* Azure Subnet Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
