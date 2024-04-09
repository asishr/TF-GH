# Azure - Management Group Module

## Introduction

This module creates a basic structure of management groups to support the subscriptions. Customization happens at the landing zone using the variables


# Examples
`terraform apply`

main.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "management_groups" {
    source                      = "../../modules/management-group"
    deploy_mgmt_groups  = true
    tags = {
        businessUnit            = "HR"
        environment             = "Production"
        costcenter              = "123456"
    }
    management_groups   = {
        root = {
            name = "rootmgmtgroup"
            subscriptions = []
            #list your subscriptions ID in this field as ["GUID1", "GUID2"]
            children = {
                child1 = {
                    name = "identity"
                    subscriptions = []
                }
                child2 = {
                    name = "platform"
                    subscriptions = []
                }
                child3 = {
                    name = "management"
                    subscriptions = []
                }
            }
        }
    }
}

```

# Resources Created
This modules creates:
* 1 Azure Parent Management Group 
* 2 Azure Chidren Management Groups

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 2.60.0 |


## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0.0 |
| null | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| management\_groups | Gets the map of management groups and attached subscriptions | `string` | n/a | yes |
| deploy\_mgmt\_groups | Toggle to enable management group deployment | `bool` | n/a | yes |
| tags | A map of the tags to use on the resources that are deployed with this module | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Management Groups |
| name | Management Group name |
| rootmgid | The ID of the Parent Management Group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Management Group Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group

