data "azurerm_subscription" "current" {
}

# Use existing subnet where PE is to be created
module "subnet_data" {
    source               = "../subnet_data"
    name                 = var.subnet_name
    virtual_network_name = var.virtual_network_name
    resource_group_name  = var.resource_group_name
}

# Create a new Private Endpoint
resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = {
   for index, subresource in var.subresource_names: index => subresource
  }
  name                                    = "${var.private_endpoint_name}-pe"
  resource_group_name                     = var.pe_resource_group_name
  location                                = var.location
  subnet_id                               = module.subnet_data.id
  tags                                    = var.tags
  private_service_connection {
    name                                  = "${var.private_endpoint_name}-connection"
    private_connection_resource_id        = var.endpoint_resource_id
    is_manual_connection                  = false
    subresource_names                     = [each.value]
  }

}
