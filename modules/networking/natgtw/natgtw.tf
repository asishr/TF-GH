# resource "azurerm_public_ip" "natgtw_pip" {
#   count = (var.create_natgw && var.create_pip) ? 1 : 0

#   name                = "${var.name}-pip"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = var.zone != null ? [var.zone] : null

#   tags = var.tags
# }

# data "azurerm_public_ip" "pip" {
#   count = (var.create_natgw && !var.create_pip && var.existing_pip_name != null) ? 1 : 0
#   name                = var.existing_pip_name
#   resource_group_name = var.existing_pip_resource_group_name == null ? var.resource_group_name : var.existing_pip_resource_group_name
# }

# resource "azurerm_public_ip_prefix" "natgtw_pip_prefix" {
#   count = (var.create_natgw && var.create_pip_prefix) ? 1 : 0
#   name                = "${var.name}-pip-prefix"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   ip_version          = "IPv4"
#   prefix_length       = var.pip_prefix_length
#   sku                 = "Standard"
#   zones               = var.zone != null ? [var.zone] : null

#   tags = var.tags
# }

# data "azurerm_public_ip_prefix" "pip_prefix" {
#   count = (var.create_natgw && !var.create_pip_prefix && var.existing_pip_prefix_name != null) ? 1 : 0
#   name                = var.existing_pip_prefix_name
#   resource_group_name = coalesce(var.existing_pip_prefix_resource_group_name, var.resource_group_name)
# }

# resource "azurerm_nat_gateway" "natgtw" {
#   count = var.create_natgw ? 1 : 0
#   name                    = var.name
#   resource_group_name     = var.resource_group_name
#   location                = var.location
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = var.idle_timeout
#   zones                   = var.zone != null ? [var.zone] : null
#   tags = var.tags
# }

# data "azurerm_nat_gateway" "this" {
#   count = var.create_natgw ? 0 : 1
#   name                = var.name
#   resource_group_name = var.resource_group_name
# }


# resource "azurerm_nat_gateway_public_ip_association" "this" {
#   count = var.create_natgw && var.public_ip_address_id != null ? 1 : 0
#   nat_gateway_id       = var.nat_gateway_id
#   public_ip_address_id = var.public_ip_address_id
# }

# resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_ips" {
#   count = var.create_natgw && var.public_ip_prefix != null ? 1 : 0
#   nat_gateway_id      = var.nat_gateway_id
#   public_ip_prefix_id = var.public_ip_prefix
# }

# resource "azurerm_subnet_nat_gateway_association" "this" {
#   #for_each = var.subnet_ids
#   nat_gateway_id = var.nat_gateway_id
#   #subnet_id      = each.value
#   subnet_id      = var.subnet_ids
# }


resource "azurerm_public_ip" "natgtw_pip" {
  count               = (var.create_natgw && var.create_pip) ? 1 : 0
  name                = "${var.pip_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
  tags = var.tags
}

resource "azurerm_nat_gateway" "nat_gateway" {
  count                   = var.create_natgw ? 1 : 0
  name                    = var.natgtw_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  tags                    = var.tags
}

resource "azurerm_subnet_nat_gateway_association" "subnet" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.natgtw_pip[0].id
}