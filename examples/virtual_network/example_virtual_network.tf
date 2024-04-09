provider "azurerm" {
  features {}
}

# module "resource_group" {
#   source   = "../../modules/common/resource_group"
#   name     = "vnet-rg"
#   location = "Canada Central"
#   tags     = { "CostCenter" = "1234" }
# }

# module "virtual_network" {
#   source   = "../../modules/networking/virtual_network"
#   name                = "vnet-rg"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   address_space       = ["10.0.0.0/16"]
#   dns_servers         = ["10.0.0.4", "10.0.0.5"]

#   subnets = [{
#     name                 = "subnet1"
#     address_prefixes     = ["10.0.1.0/24"]
#     nat_gateway_id       = module.nat_gateway.id

#     delegation = {
#       name = "delegation1"

#       service_delegation  = {
#         name    = "Microsoft.ContainerInstance/containerGroups"
#         actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
#       }
#     }
#   }]
# }

variable "locations" {
  description = "The Azure region to use."
  default     = {}
  type        = any
}
variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}
module "resource_group" {
  source                = "../../modules/common/resource_group"
  for_each              = var.locations
  name                  = "RG-${each.value.alias}-EXTHUB-01"
  location              = each.value.name
  tags                  = var.tags
}

module "exthub-vnet" {
  source                = "../../modules/networking/virtual_network"
  for_each              = var.locations
  name                  = "VN-${each.value.alias}-EXTHUB-01"
  resource_group_name   = module.resource_group[each.key].name
  location              = each.value.name
  address_space         = each.value.exthub_address_space
  # subnets               = each.value.subnets
  tags                  = var.tags

  subnets = [
    for subnet in each.value.subnets : {
      name                 = "SNET-CC-IGMF-CS-PRD-EXTHUB-${subnet.name}-01"
      address_prefixes     = subnet.address_prefixes
      nat_gateway_id = can(index(["TRUST", "UNTRUST"], subnet.name)) ? module.nat_gateway[each.key].id : null
    }
  ]
}

module "public_ip" { ## Will be replaced by ER
  source              = "../../modules/networking/public_ip"
  for_each            = var.locations
  public_ips = [{
    name                = "GW-${each.value.alias}-EXTHUB-TRUST-01-PIP"
    resource_group_name = module.resource_group[each.key].name
    location            = each.value.name
    allocation_method   = "Static"
    sku                 = "Standard"
    nat_gateway_id      = module.nat_gateway[each.key].id
    public_ip_prefix_name = "pip-prefix"
  }]
}

module "nat_gateway" {
  source              = "../../modules/networking/nat_gateway"
  for_each              = var.locations
  name                  = "NG-${each.value.alias}-EXTHUB-01"
  resource_group_name   = module.resource_group[each.key].name
  location              = each.value.name
  # sku_name                = "Standard"
  # idle_timeout_in_minutes = 10
  # zones                   = ["1"]
  # public_ip_prefix_id = azurerm_public_ip_prefix.public_ip_prefix[each.key].id
  # subnet_ids          = [""]
}