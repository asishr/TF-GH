# data "azurerm_subscription" "current" {
# }
# module "subscription" {
#   source          = "../../../modules/subscription-data"
#   subscription_id = data.azurerm_subscription.current.subscription_id
# }

# #---------------------------------------------------------
# # Blob Private endpoint
# #----------------------------------------------------------
# module private_endpoint {
#   source                          = "../../networking/private_endpoint"
#   count                           = local.private_endpoint_resources["blob"] ? 1 : 0 || local.private_endpoint_resources["file"] ? 1 : 0
#   pe_resource_group_name          = var.pe_resource_group_name      # Resource Group where the new Private Endpoint will be created. 
#   private_endpoint_name           = var.private_endpoint_name
#   subresource_names               = ["file"]
#   endpoint_resource_id            = azurerm_storage_account.storeacc[0].id
#   location                        = var.location
#   tags                            = var.tags
#   virtual_network_name            = var.virtual_network_name
#   subnet_name                     = var.subnet_name
#   resource_group_name             = var.pe_resource_group_name
#   dns = {
#     zone_ids   = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.pe_resource_group_name}/providers/Microsoft.Network/privateDnsZones/private.blob.zone"]
#     zone_name  = "private.blob.zone"
#   }
# }
