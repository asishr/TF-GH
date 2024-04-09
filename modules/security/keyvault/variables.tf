variable "key_vault_name" {
  description = "(Required) The Name of the key vault"
  type        = string
}

variable "location" {
  description = "(Required) The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) A container that holds related resources for an Azure solution"
  type = string
}

variable "key_vault_sku_pricing_tier" {
  description = "(Required) The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "(Required) A map of tags to add to all resources"
  type        = map(string)
}

variable "enabled_for_deployment" {
  description = "(Optional) Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
  type = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) Allow Disk Encryption to retrieve secrets from the vault and unwrap keys."
  type        =bool
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "(Optional) Allow Resource Manager to retrieve secrets from the key vault."
  type         = bool
  default     = true
}

variable "enable_rbac_authorization" {
  description = " (Optional) Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
  type        = bool
  default     = false
}

variable "enable_purge_protection" {
  description = "Is Purge Protection enabled for this Key Vault?"
  type        = bool
  default     = false
}


variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. The valid value can be between 7 and 90 days"
  type        = number
  default     = 90
}


variable "access_policies" {
  description = "List of access policies for the Key Vault."
  default     = []
}

variable "network_acls" {
  description = "(Optional) Network rules to apply to key vault."
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "pe_resource_group_name" {
  description = "Private endpoint Resource Group Name."
  type        = string
  default = null
}

variable  "private_endpoint_name"  {
  type        = string
  description = "Private endpoint name."
  default = null
}

variable "virtual_network_name" {
  description = "Private Endpoint Virtual Network Name"
  type = string
  default = null
}

variable "subnet_name" {
  description = "Private Endpoint Subnet Name"
  type = string
  default = null
}  

variable private_endpoint_resources_enabled {
  type        = list(string)
  description = "Determines if private endpoint should be enabled for specific resources."

  default = ["datafactory", "keyvault", "blob"]

  validation {
    condition = length([
      for resource in var.private_endpoint_resources_enabled : true

      if lower(resource) == "datafactory" ||
         lower(resource) == "keyvault"

    ]) > 0 || length(var.private_endpoint_resources_enabled) == 0

    error_message = "Value must be one of ['datafactory', 'keyvault']."
  }
}



        





