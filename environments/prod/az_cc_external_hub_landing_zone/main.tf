provider "azurerm" {
  features {}
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
  # subnets               = each.value.subnets
  subnets = [
    for subnet in each.value.subnets : {
      name              = "SNET-CC-IGMF-CS-PRD-EXTHUB-${subnet.name}-01"
      address_prefixes  = subnet.address_prefixes
      nat_gateway_id = can(index(["TRUST", "UNTRUST"], subnet.name)) ? module.nat_gateway[each.key].id : null
    }
  ]
  tags                  = var.tags
}



## Create a NAT Gateway and assiciate it with SNET-Cx-IGMF-CS-PRD-EXTHUB-UNTRUST-01 subnet
# module "natgw" {
#   source = "../modules/networking/natgtw"
#   for_each            = var.locations
#   create_natgw        = try(var.create_natgw, true)
#   create_pip          = try(var.create_pip, true)
#   #name                = "NATGTW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01"
#   natgtw_name         = "NATGTW-${each.value.alias}-${var.business_unit}-${var.environment}-UNTRUST"
#   pip_name            = "PIP-${each.value.alias}-${var.business_unit}-${var.environment}-NATGTW-UNTRUST"
#   resource_group_name = module.resource_group_pa_vn[each.key].name
#   location            = each.value.name
#   zones               = var.zones
#   idle_timeout_in_minutes = try(var.idle_timeout, null)
#   subnet_id          = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01"]
#   # create_pip          = try(var.create_pip, true)
#   # existing_pip_name   = try(var.existing_pip_name, null)
#   # existing_pip_resource_group_name = try(var.existing_pip_resource_group_name, null)
#   # create_pip_prefix   = try(var.create_pip_prefix, false)
#   # pip_prefix_length   = try(var.create_pip_prefix, false) ? try(var.pip_prefix_length, null) : null
#   # existing_pip_prefix_name          = try(var.existing_pip_prefix_name, null)
#   # existing_pip_prefix_resource_group_name = try(var.existing_pip_prefix_resource_group_name, null)
#   tags                = var.tags
#   depends_on          = [module.exthub-vnet]
# }

module "natgw" {
  source = "../modules/networking/nat_gateway"
  for_each            = var.locations
  name                = "NATGTW-${each.value.alias}-${var.business_unit}-${var.environment}-UNTRUST"
  # pip_name            = "PIP-${each.value.alias}-${var.business_unit}-${var.environment}-NATGTW-UNTRUST"
  resource_group_name = module.resource_group_pa_vn[each.key].name
  location            = each.value.location
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






