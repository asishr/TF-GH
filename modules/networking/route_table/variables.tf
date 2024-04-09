variable "name" {
  type        = string
  description = "Route Table Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region for Route Table"
}

# Optional parameters;

variable "tags" {
  description = "An override to specify tags which will be added to the Route Table."
  type        = map(string)
  default     = {}
}

variable "disable_bgp_route_propagation" {
  type        = string
  description = " (Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable." 
  default     = null
}

variable "routes" {
  type        = any
  description = "Manages a list of Routes."
  default     = []
}

variable "subnet_data" {
  description = "the lookup parameters for an existing subnet."
  type        = map(string)
  default     = {}
}