# Resource group definition;
resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
  tags     = var.tags # add tags to resource group; 
}

# # interation witn role assignment module
# module "role_assignments" {
#   source           = "../../security/role_assignment"
#   scope            = azurerm_resource_group.resource_group.id
#   role_assignments = var.role_assignments
# }
 