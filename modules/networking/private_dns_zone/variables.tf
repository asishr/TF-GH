variable "priv_dns_name" {
  type        = string
  description = "(Required) Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Required) A mapping of tags to assign to the created DNS zone."
}

variable "records" {
  description = "(Optional)List of IPv4 Addresses. Conflicts with target_resource_id."
  type        = any
  default     = {}
}


