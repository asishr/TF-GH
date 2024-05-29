variable "locations" {
  description = "The Azure region to use."
  default     = {}
  type        = any
}

variable "app_subnet_name" {
  description = "the name of the existing subnet."
  type        = string
}

variable "app_vnet_name" {
  description = "the name of the existing virtual network which contains the subnet."
  type        = string
}

variable "subnet_resource_group_name" {
  description = "resource group name of the existing subnet."
  type        = string
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

variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}


