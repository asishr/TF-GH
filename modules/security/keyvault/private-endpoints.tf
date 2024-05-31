data "azurerm_subscription" "current" {
}
module "subscription" {
  source          = "../../../modules/subscription-data"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

#---------------------------------------------------------
# Key Vault Private endpoint
#----------------------------------------------------------
module private_endpoint {
  source                          = "../../networking/private_endpoint"
  count                           = local.private_endpoint_resources["keyvault"] ? 1 : 0
  pe_resource_group_name          = var.pe_resource_group_name      # Resource Group where the new Private Endpoint will be created. 
  private_endpoint_name           = var.private_endpoint_name
  subresource_names               = ["vault"]
  endpoint_resource_id            = azurerm_key_vault.keyvault.id
  location                        = var.location
  tags                            = var.tags
  virtual_network_name            = var.virtual_network_name
  subnet_name                     = var.subnet_name
  resource_group_name             = var.pe_resource_group_name
  dns = {
    zone_ids                      = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.pe_resource_group_name}/providers/Microsoft.Network/privateDnsZones/private.kv.zone"]
    zone_name                     = "private.kv.zone"
  }
} 
                                                                                                              