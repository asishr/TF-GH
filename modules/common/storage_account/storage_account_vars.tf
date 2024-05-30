variable "resource_group_name" {
  description = "The name of the resource group to provision this resource in."
  type        = string
}

variable "name" {
  description = "The name of the storage acount."
  type        = string
}

variable "location" {
  description = "The location to provision this resource in."
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only the `Premium` tier is valid. Changing this forces a new resource to be created."
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. Changing this forces a new resource to be created when types `LRS`, `GRS` and `RAGRS` are changed to `ZRS`, `GZRS` or `RAGZRS` and vice versa."
  type        = string
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to `StorageV2`."
  type        = string
  default     = null
}

variable "access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  type        = string
  default     = null
}

variable "enable_https_traffic_only" {
  description = "Only allow HTTPs traffic?"
  type        = bool
  default     = true # Set to true per Storage Account THR requirement R_2.14.
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2` for new storage accounts."
  type        = string
  default     = "TLS1_2" # Set to TLS1_2 per Storage Account THR requirement R_2.6.
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? Defaults to `false`. If set to `true` then `account_tier` must be `Standard`."
  type        = bool
  default     = null
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? This can only be true when account_tier is Standard and account_kind is StorageV2, or account_tier is Premium and account_kind is BlockBlobStorage. Additionally, the is_hns_enabled is true, and enable_https_traffic_only is false."
  type        = bool
  default     = null
}

variable "large_file_share_enabled" {
  description = "Is Large File Share Enabled?"
  type        = bool
  default     = null
}

variable "azure_files_authentication" {
  default     = {}
  type        = any
  description = "Azure Files supports identity-based authentication with on-prem AD or Azure AD see [this link](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-active-directory-overview) for details."
}

variable "routing" {
  default     = {}
  type        = any
  description = "Can be `InternetRouting` or `MicrosoftRouting`. Internet routing directs traffic to enter the Microsoft cloud closer to the Azure Storage endpoint. Microsoft routing directs traffic to enter the Microsoft cloud closer to the requesting client."
}

variable "custom_domain" {
  default     = {}
  type        = any
  description = "A custom_domain block."
}

variable "identity" {
  default     = {}
  type        = any
  description = "An identity block."
}

variable "blob_properties" {
  default     = {}
  type        = any
  description = "A blob_properties block."
}

variable "queue_properties" {
  default     = {}
  type        = any
  description = "A queue_properties block."
}

variable "network_rules" {
  description = "A network_rules block."
  type        = any
  default     = {}
}

variable "enable_zscaler_lookup" {
  type        = bool
  description = "(Optional) Perform lookup against zScaler API for current firewall? Defaults to false"
  default     = false
}

variable "static_website" {
  default     = {}
  type        = any
  description = "A static_website block."
}

variable "containers" {
  default     = []
  type        = any
  description = "A list of storage blob containers."
}

variable "shares" {
  default     = []
  type        = any
  description = "A list of storage file share directories."
}

variable "tables" {
  default     = []
  type        = any
  description = "A list of storage tables."
}

variable "queues" {
  default     = []
  type        = any
  description = "A list of storage queues."
}

variable "custom_tags" {
  default     = {}
  type        = any
  description = "A map of custom tags to apply to the resource. Combined with `environment_variables`. Overridden by `tags`."
}

variable "environment_variables" {
  default     = {}
  type        = any
  description = "A map of environment variables to apply to the resource. Combined with `custom_tags`. Overridden by `tags`. Please refer to the [environment variables module](../../../tools/environment_variables/v1/README.md)."
}

variable "tags" {
  description = "A mapping of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  description = "[Role assignments](#role-assignments) to grant to this resource. Refer to the [role assignment module](../../../common/role_assignment/v1/README.md) for details or to [Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/catalog-permissions#who-should-be-assigned-to-what-role)."
  type        = any
  default     = {}
}

variable "diagnostic_settings" {
  description = "[Diagnostic settings](#diagnostic-settings) are used to configure streaming export of platform logs and metrics for a resource to the destination of your choice. Please refer to the [monitor diagnostic module](../../../management_tools/monitor_diagnostic/v1/README.md)."
  type        = any
  default     = []
}

variable "adls_gen2" {
  type        = any
  description = "A list of ADLS Gen2 filesystems."
  default     = []
}

variable "properties" {
  type        = any
  description = "A mapping of Key to Base64-Encoded Values which should be assigned to this Data Lake Gen2 File System."
  default     = {}
}

variable "encryption_type" {
  description = "Set to `CustomManaged` to use your own Azure Key Vault id, key name, key version and user assigned identity id."
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "The id of the Azure Key Vault containing the encryption key. Used when encryption_type set to `CustomManaged`. "
  type        = string
  default     = null
}

variable "key_name" {
  description = "The name of the encryption key. Used when encryption_type set to `CustomManaged`. "
  type        = string
  default     = null
}

variable "key_version" {
  description = "The version of the encryption key. Used when encryption_type set to `CustomManaged`.  "
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "A list of lifecycle management rules for storage account."
  type        = any
  default     = []
}

variable "private_endpoints" {
  description = "A list of the [private endpoints](#private-endpoints). Please refer to the [private endpoint module](../../../networking/private_endpoint/v1/README.md)."
  type        = any
  default     = []
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow public access to all nested items in the storage account. Defaults to true."
  type        = bool
  default     = null
}

variable "infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled?"
  type        = bool
  default     = null
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled? Defaults to true."
  type        = bool
  default     = null
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
  type        = any
  default     = null
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true."
  type        = bool
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether the public network access is enabled? Defaults to true."
  type        = bool
  default     = null
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is false"
  type        = bool
  default     = null
}

variable "queue_encryption_key_type" {
  description = "The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  type        = any
  default     = null
}

variable "table_encryption_key_type" {
  description = "The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  type        = any
  default     = null
}

variable "customer_managed_key" {
  description = "A customer_managed_key block."
  type        = any
  default     = {}
}

variable "share_properties" {
  description = "A share_properties block."
  type        = any
  default     = {}
}

variable "user_assigned_identity_id" {
  description = "The ID of a user assigned identity, used when encryption_type set to `CustomManaged`."
  type        = string
  default     = null
}