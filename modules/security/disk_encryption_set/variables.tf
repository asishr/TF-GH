variable "ade_name" {
    description = "(Required) The name of the Disk Encryption Set. Changing this forces a new resource to be created."
    type        = string
}

variable "resource_group_name" {
    description = "(Required) Specifies the name of the Resource Group where the Disk Encryption Set should exist. Changing this forces a new resource to be created."
    type        = string
}

variable "location" {
    description = " (Required) Specifies the Azure Region where the Disk Encryption Set exists. Changing this forces a new resource to be created."
    type        = string
}

# variable "key_vault_key_id" {
#     description = "(Required) Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret)."
#     type        = string
# }

variable "auto_key_rotation_enabled" {
    description = "(Optional) Boolean flag to specify whether Azure Disk Encryption Set automatically rotates encryption Key to latest version."
    type        = bool
    default     = false
}

variable "encryption_type" {
    description = " (Optional) The type of key used to encrypt the data of the disk. Possible values are EncryptionAtRestWithCustomerKey, EncryptionAtRestWithPlatformAndCustomerKeys and ConfidentialVmEncryptedWithCustomerKey. Defaults to EncryptionAtRestWithCustomerKey. Changing this forces a new resource to be created."
    type        = string
    default     = "EncryptionAtRestWithCustomerKey"
}

variable "keyvault_id" {
    description = "(Optional) Specifies the URL to a Key Vault where the Key Vault Key resides."
    type        = string
    default     = null
}

variable "des_key_name" {
    description = "(Required) Specifies the Name of the Key Vault Key (e.g. from a Key Vault Key)."
    type        = string
}

variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}