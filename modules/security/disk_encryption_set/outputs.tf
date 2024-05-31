output "principal_id" {
  value = azurerm_disk_encryption_set.encryption_set.identity.0.principal_id
}
output "tenant_id" {
  value = azurerm_disk_encryption_set.encryption_set.identity.0.tenant_id
}

output "id" {
  value = azurerm_disk_encryption_set.encryption_set.id
}

output "key_id" {
  value = azurerm_key_vault_key.des_key.id
}

output "rbac_id" {
  value = azurerm_disk_encryption_set.encryption_set.identity.0.principal_id
}