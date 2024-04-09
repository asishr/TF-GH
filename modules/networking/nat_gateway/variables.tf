variable "name" {
  description = "The Azure region to use."
  default     = null
  type        = string
}

variable "location" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = null
  type        = string
}

variable "resource_group_name" {
  description = "The Azure region to use."
  default     = null
  type        = string
}

variable "sku_name" {
  description = "The Azure region to use."
  default     = null
  type        = string
}

variable "idle_timeout_in_minutes" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = null
  type        = string
}

variable "zones" {
  description = "The Azure region to use."
  default     = []
  type        = any
}

variable "public_ip_prefix_id" {
  description = "The Azure region to use."
  default     = null
  type        = string
}

variable "tags" {
  description = "(Optional) Tags for the resource to be deployed."
  default     = null
  type        = map(any)
}

variable "subnet_ids" {
  description = "The Azure region to use."
  default     = []
  type        = any
}