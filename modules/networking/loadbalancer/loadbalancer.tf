resource "azurerm_lb" "lb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags

    dynamic "frontend_ip_configuration" {
      for_each = var.frontend_ip_configuration
      content {
        name                          = frontend_ip_configuration.value.name
        public_ip_address_id          = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
        public_ip_prefix_id           = lookup(frontend_ip_configuration.value, "public_ip_prefix_id", null) 
        subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
        private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", null)
        private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null) #== "Static" ? each.value.private_ip_address : null
        private_ip_address_version    = lookup(frontend_ip_configuration.value, "private_ip_address_version", null)
        zones                         = lookup(frontend_ip_configuration.value, "zones", null)
        gateway_load_balancer_frontend_ip_configuration_id = lookup(frontend_ip_configuration.value, "gateway_load_balancer_frontend_ip_configuration_id", null)
      }
    }
}

resource "azurerm_lb_backend_address_pool" "lb_backend" {
  for_each = { for rule in var.backend_adress_pool: rule.name => rule }
    name            = each.value.name 
    loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "probe" {
  # for_each = { for rule in var.lb_probe: rule.name => rule }
  for_each = { for probe in var.lb_probe: probe.name => probe }

  name            = each.value.name
  loadbalancer_id = azurerm_lb.lb.id
  port            = each.value.port
  protocol        = lookup(each.value, "protocol", null)
  probe_threshold = lookup(each.value, "probe_threshold", null)
  request_path    = lookup(each.value, "request_path", null)
  number_of_probes = lookup(each.value, "number_of_probes", null)
  interval_in_seconds = lookup(each.value, "interval_in_seconds", null)
}

resource "azurerm_lb_rule" "lb_rules" {
  #   for_each = { for rule in flatten([for probe_key, probe in var.lb_probe : [
  #   for rule_key, rule in var.lb_rules : merge({ probe_name = probe.name }, rule)
  #   ]
  # ]) : "${rule.probe_name}.${rule.name}" => rule }
  for_each = { for rule in var.lb_rules: "${rule.probe_name}.${rule.name}" => rule }
  name                          = each.value.name
  loadbalancer_id               = azurerm_lb.lb.id
  # probe_id                      = lookup(each.value, "probe_id", azurerm_lb_probe.probe[each.key].id)
  probe_id                      = lookup(each.value, "probe_id", azurerm_lb_probe.probe[each.value.probe_name].id)
  backend_address_pool_ids      = [for k, v in azurerm_lb_backend_address_pool.lb_backend : v.id]
  protocol                       = each.value.protocol
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_port                  = each.value.frontend_port 
  enable_floating_ip             = var.enable_floating_ip
  disable_outbound_snat          = lookup(each.value, "disable_outbound_snat", null)
  load_distribution              = try(each.value.load_distribution, null)
}

resource "azurerm_lb_outbound_rule" "outb_rules" {
  for_each = { for rule in var.outbound_rules: rule.name => rule }
  name                    = each.value.name
  loadbalancer_id         = azurerm_lb.lb.id
  backend_address_pool_id = [for k, v in azurerm_lb_backend_address_pool.lb_backend : v.id]

  protocol                 = each.value.protocol
  enable_tcp_reset         = each.value.protocol != "Udp" ? try(each.value.enable_tcp_reset, null) : null
  allocated_outbound_ports = try(each.value.allocated_outbound_ports, null)
  idle_timeout_in_minutes  = each.value.protocol != "Udp" ? try(each.value.idle_timeout_in_minutes, null) : null

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name     = frontend_ip_configuration.value.name
    }
  }
}
