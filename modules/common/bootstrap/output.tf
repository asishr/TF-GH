output "storage_account" {
  description = "The Azure Storage Account object used for the Bootstrap."
  value       = local.storage_account
}

# output "storage_account_name" {
#   description = "The Azure Storage Account object used for the Bootstrap."
#   value       = local.storage_account.name
# }

output "primary_blob_endpoint" {
  value       = local.storage_account.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "storage_share" {
  description = "The File Share object within Azure Storage used for the Bootstrap."
  value       = azurerm_storage_share.storage_share
}

# output "storage_share_name" {
#   description = "The File Share object within Azure Storage used for the Bootstrap."
#   value       = azurerm_storage_share.storage_share.name
# }

output "primary_access_key" {
  description = "The primary access key for the Azure Storage Account."
  value       = local.storage_account.primary_access_key
  sensitive   = true
}