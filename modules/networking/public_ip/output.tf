output "public_ip" {
  description = "The ID of this Public IP."
  value       = { for k, v in merge(azurerm_public_ip.public_ip) : k => {
    "id"       = v.id
    "fqdn"     = v.fqdn
    "ip_address" = v.ip_address
  } }
}

output "public_ip_prefix" {
  description = "The ID of this Public IP."
  value       = { for k, v in merge(azurerm_public_ip_prefix.public_ip_prefix) : k => {
    "id"       = v.id
  } }
}