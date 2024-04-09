resource "azurerm_firewall_policy" "firewall_policy" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    base_policy_id      = var.base_policy_id
    private_ip_ranges   = var.private_ip_ranges
    sku                 = var.sku
    sql_redirect_allowed = var.sql_redirect_allowed
    threat_intelligence_mode = var.threat_intelligence_mode


    dynamic "dns" {
        for_each = length(var.dns) > 0 ? [var.dns] : []
        content {
            proxy_enabled = dns.value.proxy_enabled
            servers = dns.value.servers
        }
    }
    
    dynamic "identity" {
        for_each = length(var.identity) > 0 ? [var.identity] : []
        content {
            type = "UserAssigned" 
            identity_ids = identity.value.identity_ids
        }
    }

    dynamic "tls_certificate" {
        for_each = length(var.tls_certificate) > 0 ? [var.tls_certificate] : []
        content {
            key_vault_secret_id = tls_certificate.value.key_vault_secret_id
            name = tls_certificate.value.name
        }
    }

    dynamic "insights" {
        for_each = length(var.insights) > 0 ? [var.insights] : []
        content {
            enabled = insights.value.enabled 
            default_log_analytics_workspace_id = insights.value.default_log_analytics_workspace_id 
            retention_in_days = insights.value.retention_in_days 

            dynamic "log_analytics_workspace" {
                for_each = lookup(insights.value, "log_analytics_workspace", [])
                content {
                    id = log_analytics_workspace.value.id
                    firewall_location = log_analytics_workspace.value.firewall_location
                }
            }
        }
    }

    dynamic "intrusion_detection" {
        for_each = length(var.intrusion_detection) > 0 ? [var.intrusion_detection] : []
        content {
            mode = lookup(intrusion_detection.value, "mode", null)
            private_ranges = lookup(intrusion_detection.value, "private_ranges", [])
        
            dynamic "signature_overrides" {
                for_each = lookup(intrusion_detection.value, "signature_overrides", [])
                content {
                    id = lookup(signature_overrides.value, "id", null)
                    state = lookup(signature_overrides.value, "state", null)
                }
            }

            dynamic "traffic_bypass" {
                for_each = lookup(intrusion_detection.value, "traffic_bypass", [])
                content {
                    name = traffic_bypass.value.name
                    protocol = traffic_bypass.value.protocol
                    description = lookup(traffic_bypass.value, "description", null)
                    destination_addresses = lookup(traffic_bypass.value, "destination_addresses", [])
                    destination_ports = lookup(traffic_bypass.value, "destination_ports", [])
                    destination_ip_groups = lookup(traffic_bypass.value, "destination_ip_groups", [])
                    source_addresses = lookup(traffic_bypass.value, "source_addresses", [])
                    source_ip_groups = lookup(traffic_bypass.value, "source_ip_groups", [])
                }
            }        
        }
    }
}



resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  for_each = { for rule in var.rule_collection_group : rule.name => rule }
  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = length(lookup(each.value, "network_rule_collection", {})) > 0 ? each.value.network_rule_collection : []
    content {
      action   = network_rule_collection.value.action
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority

      dynamic "rule" {
        for_each = length(lookup(network_rule_collection.value, "rule", {})) > 0 ? network_rule_collection.value.rule : []
        content {
          name = rule.value.name
          protocols = rule.value.protocols
          source_addresses = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports = rule.value.destination_ports
          source_ip_groups = lookup(rule.value, "source_ip_groups", [])
          destination_fqdns = lookup(rule.value, "destination_fqdns", [])
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", [])
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = length(lookup(each.value, "nat_rule_collection", {})) > 0 ? each.value.nat_rule_collection : []
    content {
      action = nat_rule_collection.value.action
      name = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority

      dynamic "rule" {
        for_each = length(lookup(nat_rule_collection.value, "rule", {})) > 0 ? nat_rule_collection.value.rule : []
        content {
          destination_address = rule.value.destination_address
          destination_ports = rule.value.destination_ports
          name = rule.value.name
          protocols = rule.value.protocols
          source_addresses = rule.value.source_addresses
          source_ip_groups = lookup(rule.value, "source_ip_groups", [])
          translated_address = rule.value.translated_address
          translated_port = rule.value.translated_port
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = length(lookup(each.value, "application_rule_collection", {})) > 0 ? each.value.application_rule_collection : []
    content {
      action = application_rule_collection.value.action
      name = application_rule_collection.value.name
      priority = application_rule_collection.value.priority

      dynamic "rule" {
        for_each = length(lookup(application_rule_collection.value, "rule", {})) > 0 ? application_rule_collection.value.rule : []
        content {
          destination_fqdn_tags = lookup(rule.value, "destination_fqdn_tags", [])
          destination_fqdns = rule.value.destination_fqdns
          name = rule.value.name
          source_addresses = rule.value.source_addresses
          source_ip_groups = lookup(rule.value, "source_ip_groups", [])

          dynamic "protocols" {  
            for_each = lookup(rule.value, "protocols", null) == null ? [] : [rule.value.protocols]
            content {
              port      = lookup(protocols.value, "port", [])
              type      = lookup(protocols.value, "type", [])
            }
          }
        }
      }
    }
  }
}
