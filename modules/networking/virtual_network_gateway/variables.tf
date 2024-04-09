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

variable "type" {
  type        = string
  description = "(Required) The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. Changing the type forces a new resource to be created."
}

variable "vpn_type" {
  description = "(Optional) The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased."
  type        = string
  default     = null
}

variable "active_active" {
  description = "(Optional) If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance SKU. If false, an active-standby gateway will be created. Defaults to false."
  type        = string
  default     = null
}

variable "enable_bgp" {
  type        = string
  description = " (Optional) If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false."
  default     = null
}

variable "sku" {
  description = "(Required) Configuration of the size and capacity of the virtual network gateway."
  type        = string
}

variable "ip_configuration" {
  description = "(Optional) Parameters of the IP configuration."
  type        = any
  default     = {}
}

variable "vpn_client_configuration" {
  type        = any
  description = "(Optional) Parameters of the VPN client configuration."
  default     = []
}
