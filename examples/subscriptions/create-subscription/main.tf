# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "subscription" {
    source                                = "../../../modules/subscription"
    billing_account_name                  = var.billing_account_name
    enrollment_account_name               = var.enrollment_account_name
    billing_profile_name                  = var.billing_profile_name
    invoice_section_name                  = var.invoice_section_name
    subscription_name                     = var.sub_name
    alias                                 = var.alias
    workload                              = var.workload
    tags                                  = var.tags
}

