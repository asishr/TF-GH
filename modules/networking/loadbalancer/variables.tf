
variable "resource_group_name" {
  description = "Name of a pre-existing Resource Group to place the resources in."
  type        = string
}

variable "location" {
  description = "Region to deploy load balancer and dependencies."
  type        = string
}

variable "name" {
  description = "The name of the load balancer."
  type        = string
}


variable "private_subnet_name" {
  type = string
  description = "Required: The value must match one of the keys present in subnets and denotes the private subnet. This is used to create the hosting LB and external interface of the firewall. If this is not speicified hosting will not be enabled. Defaults to trust."
  default = "trust"
}

variable "tags" {
  description = "Azure tags to apply to the created resources."
  default     = {}
  type        = map(string)
}

variable "frontend_ip_configuration" {
  description = "(Optional) An ip_configuration block"
  type        = any
  default     = []
}

variable "backend_adress_pool" {
  description = "Manages Load Balancer Backend Adress Pool"
  type        = any
  default     = []
}

variable "lb_probe" {
  description = "Load Balancer Probes"
  type        = any
  default     = []
}

variable "lb_rules" {
  description = "Load Balancer Rules"
  type        = any
  default     = []
}

variable "outbound_rules" {
  description = "Load Balancer Outbound Rules"
  type = any
  default = []
}

variable "enable_floating_ip" {
  description = "Optional)A floating IP is reassigned to a secondary server in case the primary server fails."
  type = bool
  default = false
}
