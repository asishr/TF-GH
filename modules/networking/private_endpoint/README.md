# Azure - Private Endpoint Terraform Module

## Introduction
* This Terraform Module creates a Private Endpoints for various resources.

## Assumptions
* An Azure virtual network, subnets, and security groups exist

# Examples
## Azure Key Vault with azurerm monitor private link scope and service
`terraform apply`

main.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

# Azurerm Provider configuration
provider "azurerm" {
  features {}
}


data "azurerm_client_config" "current" {}

module "key-vault" {
  source = "../../modules/security/keyvault"
  location                                      = "canadacentral"
  resource_group_name                           = "MonitoringADFDemoRG"
  key_vault_name                                = "demoproject-kv-dc"
  key_vault_sku_pricing_tier                    = "premium"
  enable_purge_protection                       = false
  private_endpoint_resources_enabled            = []
  virtual_network_name                          = "clpshcpvnet"
  subnet_name                                   = "default"
  pe_resource_group_name                        = "cl-ic-dev-rg"
  
  private_endpoint_name                         = "privatelink.vaultcore.azure.net"

  access_policies = [
    {
      azure_ad_service_principal_names          = ["tf-sp", "very friendly name"]
      secret_permissions                        = ["Get", "List"]
    }
  ]

  tags = {
          businessUnit                          = "HR"
          environment                           = "Production"
          costcenter                            = "123456"
    }
  }

```

# Resources Created
This modules creates:
* 1 Module `subnet_data` that will return data about a specific Azure subnet
* 2 Azure Private Endpoint Resource


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.28.0 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| subnet\_name | The required Azure Subnet details for the new Private Endpoint NIC | `string` | n/a | yes |
| virtual\_network\_name | The required Azure Virtual Network Name for the new Private Endpoint | `string` | n/a | yes |
| resource\_group\_name | The required Azure Virtual Network Name for the new Private Endpoint | `string` | n/a | yes |
| subresource\_names| A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id | `string` | n/a | yes |
| private\_endpoint\_name | Specifies the Name of the Private Endpoint | `string` | n/a | yes |
| pe\_resource\_group\_name | A container (resource group) that holds related resources for private endpoints | `string` | n/a | yes |
| location | The location/region to keep all your network resources | `string` | `canadacentral` | yes |
| endpoint\_resource\_id | The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to | `string` | `null` | no |
| dns | Azure Private DNS zone details for the Azure Private Link | `object` | n/a | yes|
| zone\_info | The list of the Private DNS Zone Supported | `map` | example: `"registry" = "privatelink.azurecr.io"` | no |
| tags | A map of the tags to use on the resources that are deployed with this module | `map(string)` | `{}` | yes |


## Outputs

| Name | Description |
|------|-------------|
| private_endpoint | List of the Private Endpoints created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Private Endpoint Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint

## Other resources

* [Azure Virtual Network documentation (Azure Documentation)](https://learn.microsoft.com/en-us/azure/virtual-network/)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)