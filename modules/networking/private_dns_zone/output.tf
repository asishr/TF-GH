output "id" {
  description = "DNS Zone resource ID."
  value       = azurerm_private_dns_zone.private_dns.id
}

output "name" {
  description = "The fully qualified domain name of the Record Set."
  value       = azurerm_private_dns_zone.private_dns.name
}

output "resource_group_name" {
  description = "Resource group name of the dns_zone"
  value       = var.resource_group_name
}

output "max_number_of_record_sets" {
  description = "Maximum number of Records in the zone."
  value       = azurerm_private_dns_zone.private_dns.max_number_of_record_sets
}
