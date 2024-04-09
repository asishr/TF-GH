# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "app_insights" {
  source                                        = "../../modules/app_insights"
  appinsights_name                              = "appinsights_test"
  location                                      = "canadacentral"
  resource_group_name                           = "DEV-RG"
  application_type                              = "web"
  tags = {
        businessUnit                            = "HR"
        environment                             = "Production"
        costcenter                              = "123456"
    }
}