# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

module "app_insights" {
    source                                      = "../../../modules/app_insights"
    appinsights_name                            = "appinsights_web"
    location                                    = "canadacentral"
    resource_group_name                         = "DEV-RG"
    application_type                            = "web"
    workspace_id                                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/DEV-RG/providers/Microsoft.OperationalInsights/workspaces/analyticsws"
    tags = {
        businessUnit                            = "HR"
        environment                             = "Production"
        costcenter                              = "123456"
    }
}