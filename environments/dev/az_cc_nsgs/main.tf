provider "azurerm" {
  features {}

}

data "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet_name
  virtual_network_name = var.app_vnet_name
  resource_group_name  = var.subnet_resource_group_name
}

# # Network Security Group for SNET-Cx-IGMF-CS-PRD-EXTHUB-UNTRUST-01 subnet
module "inbound_network_security_group" {
  source              = "../modules/networking/network_security_group"
  for_each            = var.locations
  name                = upper("SNET-${each.value.alias}-${var.business_unit}-${var.environment}-${var.app_subnet_name}-NSG")
  location            = each.value.name
  resource_group_name = data.azurerm_subnet.app_subnet.resource_group_name
  network_security_rules = each.value.inbound_snet_network_security_rules
}

# Associate the NSG to subnets
resource "azurerm_subnet_network_security_group_association" "app_snet" {
  for_each                  = var.locations
  subnet_id                 = data.azurerm_subnet.app_subnet.id
  network_security_group_id = module.inbound_network_security_group[each.key].id
}







