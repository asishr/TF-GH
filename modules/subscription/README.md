# Azure - Subscription Module

## Introduction

This module can create Azure Subscriptions under an Enterprise Agreement (EA) or a Microsoft Customer Agreement (MCA)

## Pre-requisites

The user or service principal executing this module requires the ability to create subscriptions with an Azure Enrollment Account (with the Owner role). See the Azure Documentation at https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/grant-access-to-create-subscription?tabs=rest%2Crest-2#grant-access for how to grant this.

# Examples
`terraform apply`

main.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "subscription" {
    source                                = "../../../modules/subscription"
    billing_account_name                  = "12345678"
    enrollment_account_name               = "123456"
    sub_name                              = "Subscription Name"
    alias                                 = "my_sub"
    workload                              = "Production"
    tags = {
        businessUnit                      = "HR"
        environment                       = "Production"
        costcenter                        = "123456"
    }
}

```

# Resources Created
This modules creates:
* 1 Azure Subscription
* 2 The null resource implements the standard resource lifecycle but takes no further action. This resource will be used to run bootstrap script called for each sbscription to refreshh access token or assign the new subscription to a management group
* 3 "azurerm_billing_enrollment_account_scope" data source to access information about an existing Enrollment Account Billing Scope
* 4 "azurerm_billing_mca_account_scope" data source to access an ID for the MCA Account billing scope

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
| billing\_account\_name | The Billing Account Name of the MCA account | `string` | n/a | yes |
| billing\_profile\_name | The Billing Profile Name in the above Billing Account | `string` | n/a | yes |
| invoice\_section\_name | The Invoice Section Name in the above Billing Profile | `string` | n/a | yes |
| enrollment\_account\_name | The Enrollment Account Name in the above Enterprise Account | `string` | n/a | yes |
| subscription\_name | The Name of the Subscription. This is the Display Name in the portal | `string` | n/a | yes |
| subscription\_key | Azure enrollment number and access key for Enterprise Agreement customers received when initially sign up for Azure | `string` | `null` | no |
| billing\_scope\_id | The Azure Billing Scope ID. Can be a Microsoft Customer Account Billing Scope ID, a Microsoft Partner Account Billing Scope ID or an Enrollment Billing Scope ID | `string` | `null` | no |
| subscription\_id | The ID of the Subscription. Changing this forces a new Subscription to be created | `string` | `null` | no |
| workload | The workload type of the Subscription. Possible values are Production (default) and DevTest | `string` | `DevTest` | no |
| alias | The Alias name for the subscription. Terraform will generate a new GUID if this is not supplied. Changing this forces a new Subscription to be created | `string` | `null` | no |
| create\_alias | Determines if an alias should be created for a specific subscription | `any` | `{}` | no |
| diagnostics | Specifies the name of the Diagnostic Setting | `string` | `null` | no |
| tags | A map of the tags to use on the resources that are deployed with this module | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Resource ID of the Alias |
| subscription_id | The ID of the new Subscription |
| tenant_id | The ID of the Tenant to which the subscription belongs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Subscription Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription
* Azure azurerm_billing_enrollment_account_scope Data Source Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/billing_enrollment_account_scope
* Azure azurerm_billing_enrollment_account_scope Data Source Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/billing_enrollment_account_scope

