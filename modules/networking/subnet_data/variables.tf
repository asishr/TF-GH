
variable "name" {
  description = "the name of the subnet."
  type        = string
}

variable "resource_group_name" {
  description = "the name of the name of the reource group to which the subnet is associated."
  type        = string
}

variable "virtual_network_name" {
  description = "the name of the virtual network which contains the subnet."
  type        = string
}
