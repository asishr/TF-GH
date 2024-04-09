variable "locations" {
  description = "The Azure region to use."
  default     = {}
  type        = any
}

variable "pswd" {
  description = "Initial administrative password to use for all systems. Set to null for an auto-generated password."
  type        = string
  sensitive = true
}

# variable "bootstrap_files" {
#   description = "Map of all files to copy to `inbound_storage_share_name`. The keys are local paths, the values are remote paths. Always use slash `/` as directory separator (unix-like), not the backslash `\\`. For example `{\"dir/my.txt\" = \"config/init-cfg.txt\"}`"
#   default     = {
#     "bootstrap_files/authcodes"    = "license/authcodes" # this line is only needed for common_vmseries_sku  = "byol"
#     "bootstrap_files/init-cfg.txt" = "config/init-cfg.txt"
#   }
#   type        = map(string)
# }

variable "route_tables" {
  description = "Map of Route Tables to create. Refer to the `vnet` module documentation for more information."
  type        = any
  default     = []
}

variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}

variable "panorama_private_ip_address" {
  description = "Optional static private IP address of Panorama, for example 192.168.11.22. If empty, Panorama uses dynamic assignment."
  type        = any
  default     = null
}

variable "win_uid_private_ip_address" {
  description = "Optional static private IP address of User ID Agent VM, for example 192.168.11.22. If empty, User ID Agent VM uses dynamic assignment."
  type        = any
  default     = null
}

variable "username" {
  description = "Initial administrative username to use for Panorama. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm)."
  type        = string
  default     = "panadmin"
}

variable "panorama_data_disks" {
    description = "Managed Data Disks for azure viratual machine"
    type = list(object({
        name                 = string
        storage_account_type = string
        disk_size_gb         = number
    }))
    default = [{
      name                 = "OSDISK"
      storage_account_type = "Premium_LRS"
      disk_size_gb         = 128
    }]
}

variable "panorama_sku" {
  type    = string
  default = "byol"
}

variable "panorama_version" {
  type    = string
  default = "10.1.8"
}

variable "panorama_size" {
  type    = string
  default = "Standard_F8s_v2"
}

variable "panorama_lc_size" {
  type    = string
  default = "Standard_F16s_v2"
}

variable "panorama_publisher" {
  description = "The Azure Publisher identifier for a image which should be deployed."
  type        = string
  default     = "paloaltonetworks"
}

variable "panorama_offer" {
  description = "The Azure Offer identifier for a image which should be deployed."
  type        = string
  default     = "panorama"
}

variable "environment" {
  description = "The Environment to deploy."
  default     = "PRD"
  type        = string
}

variable "business_unit" {
  description = "The business unit."
  default     = "IGMF-CS"
  type        = string
}

# variable "generate_admin_ssh_key" {
#     description = "Generates a secure private key and encodes it as PEM."
#     type        = string
#     default     = true
# }

variable "virtual_machine_prefix" {
  description   = "Prefix for VM names"
  type          = string
  default       = "AZCPRDPA"
}

