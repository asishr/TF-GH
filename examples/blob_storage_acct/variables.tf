variable "zone_name" {
  type          = string
  description   = "(Required) Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created."
}

variable "dns_zone_resource_group_name" {
  type          = string
  description   = "(Required) Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type          = string
  description   = "(Required) Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
}

variable "create_dns_zone" {
  type          = bool
  description   = "(Optional) Whether or not create the DNS zone."
  default       = true
}

variable "public_dns_zone" {
  type          = bool
  description   = "(Optional) Whether or not the created DNS zone is public."
  default       = false
}

# Mandatory tags
variable "business_unit" {
  description = "rba.businessUnit"
  type        = string
}

variable "environment" {
  description = "rba.environment"
  type        = string
}

variable "location" {
  description = "rba.azureRegion"
  type        = string
}


variable "subscription_type" {
  description = "rba.subscriptionType"
  type        = string
}

variable "billing_application" {
  description = "billingApplication"
  type        = string
  default     = ""
}

variable "billing_code" {
  description = "billingCode"
  type        = string
  default     = ""
}

variable "solution_group" {
  description = "solutionGroup"
  type        = string
  default     = ""
}

variable "solution_id" {
  description = "solutionID"
  type        = string
  default     = ""
}

variable "solution_name" {
  description = "solutionName"
  type        = string
  default     = ""
}

variable "product_group" {
  description = "rba.productGroup or [a-z0-9]{2,12}"
  type        = string
  default     = ""

  validation {
    condition     = length(regexall("[a-z0-9]{2,12}", var.product_group)) == 1
    error_message = "ERROR: product_group must [a-z0-9]{2,12}."
  }
}

variable "product_name" {
  description = "rba.productName"
  type        = string
  default     = ""

  validation {
    condition     = length(regexall("[a-z0-9]{3,16}", var.product_name)) == 1
    error_message = "ERROR: product_name must be [a-z0-9]{3,16}."
  }
}


variable "resource_group_type" {
  description = "rba.resourceGroupType"
  type        = string
}

variable "project" {
  description = "PSHCP Project"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Vnet Resource group name"
  type        = string
}

variable "sta_resource_group_name" {
  description = "Storage Account Resource group name"
  type        = string
}

variable "address_space" {
  description = "CIDRs for virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets. Keys are subnet names, Allowed values are the same as for subnet_defaults"
  type        = any
  default     = {}

  validation {
    condition = (length(compact([for subnet in var.subnets : (!lookup(subnet, "configure_nsg_rules", true) &&
      (contains(keys(subnet), "allow_internet_outbound") ||
        contains(keys(subnet), "allow_lb_inbound") ||
        contains(keys(subnet), "allow_vnet_inbound") ||
      contains(keys(subnet), "allow_vnet_outbound")) ?
    "invalid" : "")])) == 0)
    error_message = "Subnet rules not allowed when configure_nsg_rules is set to \"false\"."
  }
}

variable "storage_account_name" {
  description = "Storage Account name"
  type        = string
}

variable "min_tls_versionallow_blob_public_access" {}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}
variable "file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}
variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}

variable "private_dns_zone_name" {
  description = "Private DNS Zone name"
  type        = string
}

variable "pe_resource_name" {
  type        = string
  description = "(Required) Specifies the name. Changing this forces a new resource to be created."
}

variable "pe_resource_group_name" {
  description = "The name of the resource group. Changing this forces a new resource to be created."
  default     = null
}

# variable "subresource_names" {
#   default = []
# }

# variable "private_dns" {
#   default = {}
# }
# Optional free-form tags
variable "tags" {
  type        = map(string)
  description = "A map of additional tags to add to the tags output"
  default     = {}
}

variable environment_type {}

variable vnet_name {}

variable "security_level" {}

variable "storage_type" {}

variable "networking_rg_name" {}

variable "workloads_rg_name" {}

variable "private_endpoint_name" {}


# variable pe_network {
#     type = object({
#       resource_group_name = string
#       vnet_name           = string
#       subnet_name         = string
#     })
#   }

