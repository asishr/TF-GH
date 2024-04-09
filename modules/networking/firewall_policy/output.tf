output "id" {
  description = "The ID of this Public IP."
  value       = azurerm_firewall_policy.firewall_policy.id
}

output "child_policies" {
  description = "A list of reference to child Firewall Policies of this Firewall Policy."
  value       = azurerm_firewall_policy.firewall_policy.child_policies 
}

output "firewalls" {
  description = "A list of references to Azure Firewalls that this Firewall Policy is associated with."
  value       = azurerm_firewall_policy.firewall_policy.firewalls 
}

output "rule_collection_groups" {
  description = "A list of references to Firewall Policy Rule Collection Groups that belongs to this Firewall Policy."
  value       = azurerm_firewall_policy.firewall_policy.rule_collection_groups 
}