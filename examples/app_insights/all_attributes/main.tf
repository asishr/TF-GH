# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "app_insights" {
    source                                      = "../../modules/app_insights"
    appinsights_name                            = "appinsights_web"
    location                                    = "canadacentral"
    resource_group_name                         = "DEV-RG"
    application_type                            = "web"
    daily_data_cap_in_gb                        = 100
    daily_data_cap_notifications_disabled       = false
    retention_in_days                           = 180
    sampling_percentage                         = 50
    disable_ip_masking                          = true
    tags = {
        businessUnit                            = "HR"
        environment                             = "Production"
        costcenter                              = "123456"
    }
}