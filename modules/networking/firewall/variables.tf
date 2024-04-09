variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type = string
  description = " (Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet."
}

variable "sku_tier" {
  type = string
  description = "(Required) SKU tier of the Firewall. Possible values are Premium, Standard and Basic."
}

# Optional parameters;

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Firewall Policy applied to this Firewall."
  type        = string
  default     = null
}

variable "ip_configuration" {
  description = "(Optional) An ip_configuration block"
  #type        = map(string)
  type        = any
  default     = null
}


variable "dns_servers" {
  description = "(Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  type        = any
  default     = null
}

variable "private_ip_ranges" {
  description = "(Optional) A list of SNAT private CIDR IP ranges, or the special string IANAPrivateRanges, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "management_ip_configuration" {
  description = "(Optional) A management_ip_configuration block as documented below, which allows force-tunnelling of traffic to be performed by the firewall. Adding or removing this block or changing the subnet_id in an existing block forces a new resource to be created."
  type        = map(string)
  default     = {}
}

variable "threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert and Deny. Defaults to Alert."
  type        = string
  default     = null
}

variable "virtual_hub" {
  description = "(Optional) A virtual_hub block"
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "(Optional) Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  type        = list(string)
  default     = []
}

