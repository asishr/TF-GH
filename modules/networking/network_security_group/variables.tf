variable "name" {
  type        = string
  description = "Network Security Group Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region for Network Security Group"
}


variable "network_security_rules" {
  type        = any
  description = "Manages a list of Network Security Rules."
  default     = []
}

variable "subnet_data" {
  type        = any
  description = "The lookup parameters for an existing subnet."
  default     = {}
}

variable "subnet_id" {
  description = "(Optional) Subnet ID for NSG Association"
  type        = string
  default     = null
}