output "name" {
  description = "Firewall name"
  value       = azurerm_firewall.firewall.name 
}

output "id" {
  description = "The ID of this Public IP."
  value       = azurerm_firewall.firewall.id
}

output "ip_configuration" {
  description = "The IP address value that was allocated."
  value       = azurerm_firewall.firewall.ip_configuration 
}

output "fqdn" {
  description = "Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone"
  value       = azurerm_firewall.firewall.virtual_hub 
}