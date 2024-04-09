data "azurerm_client_config" "current" {}

#---------------------------------------------------------
# Azure Application Insights creation or selection 
#----------------------------------------------------------

resource "azurerm_application_insights" "appinsights" {
  name                                  = var.appinsights_name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  application_type                      = var.application_type
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  retention_in_days                     = var.retention_in_days
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  workspace_id                          = var.workspace_id
  tags                                  = var.tags
}