# storage account
#  The ID of the Storage Account.                                                               
output "name" {
  value = azurerm_storage_account.storage_account.name
}

output "id" {
  value = azurerm_storage_account.storage_account.id
}
output "account_replication_type" {
  value = azurerm_storage_account.storage_account.account_replication_type
}

#  The primary location of the storage account.                                                 
output "primary_location" {
  value = azurerm_storage_account.storage_account.primary_location
}

#  The secondary location of the storage account.                                               
output "secondary_location" {
  value = azurerm_storage_account.storage_account.secondary_location
}

#  The endpoint URL for blob storage in the primary location.                                   
output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}

#  The hostname with port if applicable for blob storage in the primary location.               
output "primary_blob_host" {
  value = azurerm_storage_account.storage_account.primary_blob_host
}

#  The endpoint URL for blob storage in the secondary location.                                 
output "secondary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_blob_endpoint
}

#  The hostname with port if applicable for blob storage in the secondary location.             
output "secondary_blob_host" {
  value = azurerm_storage_account.storage_account.secondary_blob_host
}

#  The endpoint URL for queue storage in the primary locatio                                    
output "primary_queue_endpoint" {
  value = azurerm_storage_account.storage_account.primary_queue_endpoint
}

#  The hostname with port if applicable for queue storage in the primary location               
output "primary_queue_host" {
  value = azurerm_storage_account.storage_account.primary_queue_host
}

#  The endpoint URL for queue storage in the secondary location.                                
output "secondary_queue_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_queue_endpoint
}

#  The hostname with port if applicable for queue storage in the secondary location.            
output "secondary_queue_host" {
  value = azurerm_storage_account.storage_account.secondary_queue_host
}

#  The endpoint URL for table storage in the primary location                                   
output "primary_table_endpoint" {
  value = azurerm_storage_account.storage_account.primary_table_endpoint
}

#  The hostname with port if applicable for table storage in the primary location               
output "primary_table_host" {
  value = azurerm_storage_account.storage_account.primary_table_host
}

#  The endpoint URL for table storage in the secondary location.                                
output "secondary_table_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_table_endpoint
}

#  The hostname with port if applicable for table storage in the secondary location.            
output "secondary_table_host" {
  value = azurerm_storage_account.storage_account.secondary_table_host
}

#  The endpoint URL for file storage in the primary location                                    
output "primary_file_endpoint" {
  value = azurerm_storage_account.storage_account.primary_file_endpoint
}

#  The hostname with port if applicable for file storage in the primary location.               
output "primary_file_host" {
  value = azurerm_storage_account.storage_account.primary_file_host
}

#  The endpoint URL for file storage in the secondary location                                  
output "secondary_file_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_file_endpoint
}

#  The hostname with port if applicable for file storage in the secondary location              
output "secondary_file_host" {
  value = azurerm_storage_account.storage_account.secondary_file_host
}

#  The endpoint URL for DFS storage in the primary location                                     
output "primary_dfs_endpoint" {
  value = azurerm_storage_account.storage_account.primary_dfs_endpoint
}

#  The hostname with port if applicable for DFS storage in the primary location.                
output "primary_dfs_host" {
  value = azurerm_storage_account.storage_account.primary_dfs_host
}

#  The endpoint URL for DFS storage in the secondary location.                                  
output "secondary_dfs_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_dfs_endpoint
}

#  The hostname with port if applicable for DFS storage in the secondary location               
output "secondary_dfs_host" {
  value = azurerm_storage_account.storage_account.secondary_dfs_host
}

#  The endpoint URL for web storage in the primary location.                                    
output "primary_web_endpoint" {
  value = azurerm_storage_account.storage_account.primary_web_endpoint
}

#  The hostname with port if applicable for web storage in the primary location                 
output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}

#  The endpoint URL for web storage in the secondary location                                   
output "secondary_web_endpoint" {
  value = azurerm_storage_account.storage_account.secondary_web_endpoint
}

#  The hostname with port if applicable for web storage in the secondary location.              
output "secondary_web_host" {
  value = azurerm_storage_account.storage_account.secondary_web_host
}

#  The primary access key for the storage account                                               
output "primary_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

#  The secondary access key for the storage account                                             
output "secondary_access_key" {
  value     = azurerm_storage_account.storage_account.secondary_access_key
  sensitive = true
}

#  The connection string associated with the primary location                                   
output "primary_connection_string" {
  value     = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}

#  The connection string associated with the secondary location                                 
output "secondary_connection_string" {
  value     = azurerm_storage_account.storage_account.secondary_connection_string
  sensitive = true
}

#  The connection string associated with the primary blob location                              
output "primary_blob_connection_string" {
  value     = azurerm_storage_account.storage_account.primary_blob_connection_string
  sensitive = true
}

#  The connection string associated with the secondary blob location.                           
output "secondary_blob_connection_string" {
  value     = azurerm_storage_account.storage_account.secondary_blob_connection_string
  sensitive = true
}

output "identity" {
  value = azurerm_storage_account.storage_account.identity
  # principal_id  : The Principal ID for the Service Principal associated with the Identity of this Storage Account.
  # tenant_id  : The Tenant ID for the Service Principal associated with the Identity of this Storage Account
}

#   container and blobs
output "containers" {
  value = azurerm_storage_container.blob_container
}
# blob 
output "blobs" {
  value = azurerm_storage_blob.blob_storage
}
# share and directories 
output "shares" {
  value = azurerm_storage_share.storage_share
}
# ddirectories shares 
output "directories" {
  value = azurerm_storage_share_directory.storage_share_directory
}
# table
output "tables" {
  value = azurerm_storage_table.storage_table
}
#  queue
output "queues" {
  value = azurerm_storage_queue.storage_queue
}

#   container and blobs
output "gen2_filesystem" {
  value = azurerm_storage_data_lake_gen2_filesystem.gen2_filesystem
}
#  the map  build  used to create role assignments
#output "storage_assignments" {
#  value = local.storage_assignments
#}

# output "role_assignment" {
#   value = module.role_assignments
# }


output "storage_sync" {
  value = azurerm_storage_sync.storage_sync
}

# map with key = share.name
output "storage_sync_groups" {
  value = azurerm_storage_sync_group.sync_group
}
# map with key = share.name
output "sync_cloud_endpoint" {
  value = azurerm_storage_sync_cloud_endpoint.sync_cloud_endpoint
}

output "flattened_data" {
  value = local.flattened_data
}

output "diagnostics" {
  value = local.storage_diagnostics_settings
}


