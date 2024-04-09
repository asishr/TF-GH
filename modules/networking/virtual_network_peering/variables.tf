variable "resource_group_name" {
  description = "Name of Resource Group"
  type        = string
}

variable "name" {
  description = "Name to be applied to resources"
  type        = string
}

variable "virtual_network_name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "remote_virtual_network_id" {
  type        = string
  description = "(Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created."
  default     = null
}

variable "allow_virtual_network_access" {
  description = "(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true."
  type        = bool
  default     = null
}

variable "allow_forwarded_traffic" {
  description = "(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false."
  type        = bool
  default     = null
}

variable "allow_gateway_transit" {
  type        = any
  description = "(Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network."
  default     = null
}

variable "use_remote_gateways" {
  type        = bool
  description = " (Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false"
  default     = null
}
