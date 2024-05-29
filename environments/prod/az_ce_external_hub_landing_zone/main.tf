provider "azurerm" {
  features {}

  client_id       = "9c699268-0e50-4f69-9703-cd7782b11534"
  client_secret   = "pj~8Q~fzMz6Vvjgn681oaGcGZX1t1~DxtYcVtbe0"
  tenant_id       = "dc411c63-1f52-4491-bb51-c4d215a1de23"
  subscription_id = "d674c517-8ec5-4b7d-b4fd-71f62f72f0fb"

}

# # Generate a random password.
resource "random_password" "this" {
  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "_%@"
}

# # Create the Resource Group for Palo Alto Virtual Network.
module "resource_group_pa_vn" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-VN"
  location              = each.value.name
  tags                  = var.tags
}

# # Create the Resource Group for External Hub Resources.
module "resource_group_exthub" {
  source                = "../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-01"
  location              = each.value.name
  tags                  = var.tags
}


# # Create the transit External Hub network which holds the PaloAlto Firewall components (both inbound and outbound ones).
module "exthub-vnet" {
  source                = "../modules/networking/virtual_network"
  for_each              = var.locations
  name                  = "VN-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-01"
  resource_group_name   = module.resource_group_pa_vn[each.key].name
  location              = each.value.name
  address_space         = each.value.exthub_address_space
  subnets               = each.value.subnets
  tags                  = var.tags
}

# # Network Security Group for SNET-Cx-IGMF-CS-PRD-EXTHUB-UNTRUST-01 subnet
module "untrust_network_security_group" {
  source              = "../modules/networking/network_security_group"
  for_each            = var.locations
  name                = "SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-NSG"
  location            = each.value.name
  resource_group_name = module.resource_group_pa_vn[each.key].name
  network_security_rules = each.value.untrust_snet_network_security_rules
  depends_on = [
    module.exthub-vnet
  ]
}

# # Network Security Group for SNET-Cx-IGMF-CS-PRD-EXTHUB-TRUST-01 subnet
module "trust_network_security_group" {
  source              = "../modules/networking/network_security_group"
  for_each            = var.locations
  name                = "SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-TRUST-01-NSG"
  location            = each.value.name
  resource_group_name = module.resource_group_pa_vn[each.key].name
  network_security_rules = each.value.trust_snet_network_security_rules
  depends_on = [
    module.exthub-vnet
  ]
}

# # Network Security Group for SNET-Cx-IGMF-CS-PRD-EXTHUB-MGMT-01 subnet
module "exthub_mgmt_network_security_group" {
  source              = "../modules/networking/network_security_group"
  for_each            = var.locations
  name                = "SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-MGMT-01-NSG"
  location            = each.value.name
  resource_group_name = module.resource_group_pa_vn[each.key].name
  network_security_rules = each.value.exthub_mgmt_snet_network_security_rules
  depends_on = [
    module.exthub-vnet
  ]
}

# # Network Security Group for AzureFirewallSubnet 
# module "afw_network_security_group" {
#   source              = "../modules/networking/network_security_group"
#   for_each            = var.locations
#   name                = "AzureFirewallSubnet-NSG"
#   location            = each.value.name
#   resource_group_name = module.resource_group_pa_vn[each.key].name
#   #subnet_id           = module.exthub-vnet[each.key].subnet_ids["AzureFirewallSubnet"]
#   network_security_rules = each.value.afw_snet_network_security_rules
#   depends_on = [
#     module.exthub-vnet
#   ]
# }

# Associate the NSG to subnets

resource "azurerm_subnet_network_security_group_association" "untrust_snet" {
  for_each                  = var.locations
  subnet_id                 = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01"]
  network_security_group_id = module.untrust_network_security_group[each.key].id
}

resource "azurerm_subnet_network_security_group_association" "trust_snet" {
  for_each                  = var.locations
  subnet_id                 = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-TRUST-01"]
  network_security_group_id = module.trust_network_security_group[each.key].id
}

resource "azurerm_subnet_network_security_group_association" "exthub_mgmt_snet" {
  for_each                  = var.locations
  subnet_id                 = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-MGMT-01"]
  network_security_group_id = module.exthub_mgmt_network_security_group[each.key].id
}

# resource "azurerm_subnet_network_security_group_association" "afw_snet" {
#   for_each                  = var.locations
#   subnet_id                 = module.exthub-vnet[each.key].subnet_ids["AzureFirewallSubnet"]
#   network_security_group_id = module.afw_network_security_group[each.key].id
# }






