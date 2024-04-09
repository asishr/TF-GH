output "id" {
  value = format("/subscriptions/%s", try(azurerm_subscription.sub.0.subscription_id, var.subscription_id))
  description = "The Resource ID of the Alias."
}
output "subscription_id" {
  value = try(azurerm_subscription.sub.0.subscription_id, var.subscription_id)
  description = "The ID of the new Subscription."
}

output "tenant_id" {
  value = azurerm_subscription.sub.0.tenant_id
  description = "The ID of the Tenant to which the subscription belongs."
}
