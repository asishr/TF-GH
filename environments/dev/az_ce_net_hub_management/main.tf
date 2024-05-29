provider "azurerm" {
  features {} 
}

# # Generate a random password.
# resource "random_password" "this" {
#   length           = 16
#   min_lower        = 16 - 4
#   min_numeric      = 1
#   min_special      = 1
#   min_upper        = 1
#   special          = true
#   override_special = "_%@"
# }

# Create the Resource Group for Panorama Management Virtual Network.
module "resource_group_mgmt_vn" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-HUB-MGMT-VN"
  location              = each.value.name
  tags                  = var.tags
}

# Create the Resource Group for Panorama VMs.
module "resource_group_pano" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-PA-PANORAMA"
  location              = each.value.name
  tags                  = var.tags
}

# Create the Resource Group for Win User-ID Agent.
module "resource_group_uid" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-PA-WIN-USERID-AGENT"
  location              = each.value.name
  tags                  = var.tags
}

# Create the Resource Group for Log Collector.
module "resource_group_log_col" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-PA-LOG-COL"
  location              = each.value.name
  tags                  = var.tags
}

# Create the transit network which holds the VM-Series (both inbound and outbound ones).
module "mgmt_vnet" {
  source              = "../modules/networking/virtual_network"
  for_each            = var.locations
  name                = "VN-${each.value.alias}-${var.business_unit}-${var.environment}-HUB-MGMT-01"
  resource_group_name = module.resource_group_mgmt_vn[each.key].name
  location            = each.value.name
  address_space       = each.value.mgmt_address_space
  subnets             = each.value.subnets
  tags                = var.tags
}

# Network Security Group for SNET-Cx-NET-PRD-PAFW-MGMT-01 
module "mgmt_network_security_group" {
  source              = "../modules/networking/network_security_group"
  for_each            = var.locations
  name                = "SNET-${each.value.alias}-NET-${var.environment}-HUB-PAFW-MGMT-01-NSG"
  location            = each.value.name
  resource_group_name = module.resource_group_mgmt_vn[each.key].name
  network_security_rules = each.value.mgmt_snet_network_security_rules
  depends_on = [
    module.mgmt_vnet
  ]
}

# Associate the NSG to subnets
resource "azurerm_subnet_network_security_group_association" "mgmt_snet" {
  for_each                  = var.locations
  subnet_id                 = module.mgmt_vnet[each.key].subnet_ids["SNET-${each.value.alias}-NET-${var.environment}-HUB-PAFW-MGMT-01"]
  network_security_group_id = module.mgmt_network_security_group[each.key].id
  depends_on = [
    module.mgmt_network_security_group
  ]
}





