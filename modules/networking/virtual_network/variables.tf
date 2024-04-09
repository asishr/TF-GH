variable "resource_group_name" {
  description = "Name of Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "name" {
  description = "Name to be applied to resources"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  type        = any
  description = "Manages a list of Subnets."
  default     = []
}

variable "address_space" {
  description = "CIDRs for virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver"
  type        = list(string)
  default     = null
}

variable "bgp_community" {
  type        = string
  description = " (Optional) The BGP community attribute in format <as-number>:<community-value>"
  default     = null
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist."
  type        = string
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  type        = number
  default     = null
}

variable "ddos_protection_plan" {
  type        = any
  description = "(Optional) A ddos_protection_plan block "
  default     = []
}
