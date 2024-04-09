resource "azurerm_firewall" "firewall" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    sku_name            = var.sku_name
    sku_tier            = var.sku_tier
    firewall_policy_id  = var.firewall_policy_id
    dns_servers         = var.dns_servers
    private_ip_ranges   = var.private_ip_ranges
    threat_intel_mode   = var.threat_intel_mode
    zones               = var.zones

    dynamic "ip_configuration" {
        for_each = length(var.ip_configuration) > 0 ? var.ip_configuration : []
        content {
            name    = ip_configuration.value.name
            subnet_id    = lookup(ip_configuration.value, "subnet_id", null)
            public_ip_address_id = ip_configuration.value.public_ip_address_id
        }
    }
    
    dynamic "virtual_hub" {
        for_each = length(var.virtual_hub) > 0 ? [var.virtual_hub] : []
        content {
            virtual_hub_id  = virtual_hub.value.virtual_hub_id 
            public_ip_count = virtual_hub.value.public_ip_count
        }
    }

    dynamic "management_ip_configuration" {
        for_each = length(var.management_ip_configuration) > 0 ? [var.management_ip_configuration] : []
        content {
            name  = management_ip_configuration.value.name 
            subnet_id  = management_ip_configuration.value.subnet_id 
            public_ip_address_id = management_ip_configuration.value.public_ip_address_id 
        }
    }
}


