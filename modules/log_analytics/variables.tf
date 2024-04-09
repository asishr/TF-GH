#---------------------------------------
# REQUIRED INPUTS
#---------------------------------------
variable "tags" {
  type        = map(string)
  description = "Key/value pairs of tags that will be applied to all resources in this module."
}

variable law_name {
    type = string
    description = "Azure Log Analytics Workspace Name"
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
}

variable "ampls_name" {
  description = "(Required) The name of the Azure Monitor Private Link Scope."
  type = string
}

variable "ampls_link_name" {
  description = "(Required) Specifies the name of this Private Link Service."
  type = string
}

variable "create_new_workspace" {
  type        = bool
  description = "Whether or not you wish to create a new workspace, if set to true, a new one will be created, if set to false, a data read will be performed on a data source"
}


#---------------------------------------
# OPTIONAL INPUTS
#---------------------------------------

variable "daily_quota_gb" {
  type        = number
  description = "The amount of gb set for max daily ingetion"
  default     = 0.5
}

variable "internet_ingestion_enabled" {
  type        = bool
  description = "Whether internet ingestion is enabled"
  default     = false
}

variable "internet_query_enabled" {
  type        = bool
  description = "Whether or not your workspace can be queried from the internet"
  default     = false
}

variable "law_sku" {
  type        = string
  description = "The sku of the log analytics workspace"
  default     = null
}

variable "reservation_capacity_in_gb_per_day" {
  type        = string
  description = "The reservation capacity gb per day, can only be used with CapacityReservation SKU"
  default     = null
}

variable "retention_in_days" {
  type        = number
  description = "The number of days for retention, between 7 and 730"
  default     = 7
}