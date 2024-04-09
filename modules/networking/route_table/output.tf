output "id" {
  description = "Route id"
  value       = [for rt in azurerm_route.route : rt.id]
}
