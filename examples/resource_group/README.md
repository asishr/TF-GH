# Resource Group

This module creates a resource group in any valid Azure subscription.  Additional information can be found in the official Terraform [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) docs.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| role_assignments | ../../common/role_assignment | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | the Azure Region where the resource group should exist (eg. canadaeast). | `string` | n/a | yes |
| name | name of the resource group | `string` | n/a | yes |
| role_assignments | identities and roles mapping . | `any` | `{}` | no |
| tags | An override to specify tags which will be added to the resoruce_group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | outputs the Azure ID of the resource group |
| location | outputs the Azure Region where the resource group exists ie. Canada East |
| name | outputs the name of the resource group |

<br />

<!-- END_TF_DOCS -->