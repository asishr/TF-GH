output "private_endpoint" {
  value = azurerm_private_endpoint.private_endpoint[*]
  description = "List of the Private Endpoints created."
}