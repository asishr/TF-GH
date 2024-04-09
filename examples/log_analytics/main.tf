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
    resource_group_name                   = "MGMT-Dev-RG"
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
output "log_analytics" {
  value = module.log_analytics
  sensitive = true
}
