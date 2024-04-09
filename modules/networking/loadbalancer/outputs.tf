output "backend_pool_id" {
  description = "The identifier of the backend pool."
  value =  [for k, v in azurerm_lb_backend_address_pool.lb_backend : v.id]
}

output "lb_probe" {
  description = "The identifier of the load balancer probe."
  value =  merge(azurerm_lb_probe.probe)
}

output "lb_probe_id" {
  description = "The identifier of the load balancer probe."
  value =  values(azurerm_lb_probe.probe)[*].id
}

output "frontend_ip_configs" {
  description = "Map of IP addresses, one per each entry of `frontend_ips` input. Contains public IP address for the frontends that have it, private IP address otherwise."
  value       = azurerm_lb.lb.frontend_ip_configuration
}

output "health_probe" {
  description = "The health probe object."
  value       = azurerm_lb_probe.probe
}

