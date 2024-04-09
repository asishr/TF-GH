resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
  dns_servers         = var.dns_servers
  bgp_community       = var.bgp_community
  edge_zone           = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  dynamic "ddos_protection_plan" {
    for_each = length(var.ddos_protection_plan) > 0 ? [var.ddos_protection_plan] : []
    content {
      id     = lookup(var.ddos_protection_plan, "type", null)
      enable = lookup(var.ddos_protection_plan, "enable", null)
    }
  }
}

resource "azurerm_subnet" "subnet" {
  for_each                    = { for sub in var.subnets : sub.name => sub }
  name                        = each.value.name
  address_prefixes            = each.value.address_prefixes
  resource_group_name         = lookup(each.value, "resource_group_name", azurerm_virtual_network.vnet.resource_group_name)
  virtual_network_name        = lookup(each.value, "virtual_network_name", azurerm_virtual_network.vnet.name) 

  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", null)

  ## Will be available in version 4.0 of the AzureRM ##
  #private_endpoint_network_policies_enabled = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  #private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)

  service_endpoints = lookup(each.value, "service_endpoints", null)
  service_endpoint_policy_ids = lookup(each.value, "service_endpoint_policy_ids", null) 

  dynamic "delegation" {
    for_each = length(lookup(each.value, "delegation", {})) > 0 ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = length(lookup(delegation.value, "service_delegation", {})) > 0 ? [delegation.value.service_delegation] : []
        content {
          name   = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }
}

locals {
  subnets_with_nat_gateway = {
    for subnet in var.subnets :
    subnet.name => subnet.nat_gateway_id
    if subnet.nat_gateway_id != null
  }
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  for_each = local.subnets_with_nat_gateway
  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = each.value
}
