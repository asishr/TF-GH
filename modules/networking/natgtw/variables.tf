# variable "name" {
#   description = "Name of a NAT Gateway."
#   type        = string
# }

# variable "create_natgw" {
#   description = <<-EOF
#   Triggers creation of a NAT Gateway when set to `true`.
  
#   Set it to `false` to source an existing resource. In this 'mode' the module will only bind an existing NAT Gateway to specified subnets.
#   EOF
#   default     = true
#   type        = bool
# }

# variable "resource_group_name" {
#   description = "Name of a Resource Group hosting the NAT Gateway (either the existing one or the one that will be created)."
#   type        = string
# }

# variable "location" {
#   description = "Azure region. Only for newly created resources."
#   type        = string
# }

# variable "tags" {
#   description = "A map of tags that will be assigned to resources created by this module. Only for newly created resources."
#   default     = {}
#   type        = map(string)
# }

# variable "zone" {
#   description = <<-EOF
#   Controls if the NAT Gateway will be bound to a specific zone or not. This is a string with the zone number or `null`. Only for newly created resources.

#   NAT Gateway is not zone-redundant. It is a zonal resource. It means that it's always deployed in a zone. It's up to the user to decide if a zone will be specified during resource deployment or if Azure will take that decision for the user. 
#   Keep in mind that regardless of the fact that NAT Gateway is placed in a specific zone it can serve traffic for resources in all zones. But if that zone becomes unavailable resources in other zones will loose internet connectivity. 

#   For design considerations, limitation and examples of zone-resiliency architecture please refer to [Microsoft documentation](https://learn.microsoft.com/en-us/azure/virtual-network/nat-gateway/nat-availability-zones).
#   EOF
#   default     = null
#   type        = string
# }

# variable "idle_timeout" {
#   description = "Connection IDLE timeout in minutes. Only for newly created resources."
#   default     = null
#   type        = number
# }

# variable "subnet_ids" {
#   description = "A map of subnet IDs what will be bound with this NAT Gateway. Value is the subnet ID, key value does not matter but should be unique, typically it can be a subnet name."
#   type        = any
# }

# variable "create_pip" {
#   description = <<-EOF
#   Set `true` to create a Public IP resource that will be connected to newly created NAT Gateway. Not used when NAT Gateway is only sourced.

#   Setting this property to `false` has two meanings:
#   * when `existing_pip_name` is `null` simply no Public IP will be created
#   * when `existing_pip_name` is set to a name of an exiting Public IP resource it will be sourced and associated to this NAT Gateway.
#   EOF
#   default     = true
#   type        = bool
# }

# variable "existing_pip_name" {
#   description = "Name of an existing Public IP resource to associate with the NAT Gateway. Only for newly created resources."
#   default     = null
#   type        = string
# }

# variable "existing_pip_resource_group_name" {
#   description = "Name of a resource group hosting the Public IP resource specified in `existing_pip_name`. When omitted Resource Group specified in `resource_group_name` will be used."
#   default     = null
#   type        = string
# }

# variable "create_pip_prefix" {
#   description = <<-EOF
#   Set `true` to create a Public IP Prefix resource that will be connected to newly created NAT Gateway. Not used when NAT Gateway is only sourced.

#   Setting this property to `false` has two meanings:
#   * when `existing_pip_prefix_name` is `null` simply no Public IP Prefix will be created
#   * when `existing_pip_prefix_name` is set to a name of an exiting Public IP Prefix resource it will be sourced and associated to this NAT Gateway.
#   EOF
#   default     = false
#   type        = bool
# }

# variable "pip_prefix_length" {
#   description = <<-EOF
#   Number of bits of the Public IP Prefix. This basically specifies how many IP addresses are reserved. Azure default is `/28`.

#   This value can be between `0` and `31` but can be limited by limits set on Subscription level.
#   EOF
#   default     = null
#   type        = number
# }

# variable "existing_pip_prefix_name" {
#   description = "Name of an existing Public IP Prefix resource to associate with the NAT Gateway. Only for newly created resources."
#   default     = null
#   type        = string
# }

# variable "existing_pip_prefix_resource_group_name" {
#   description = "Name of a resource group hosting the Public IP Prefix resource specified in `existing_pip_name`. When omitted Resource Group specified in `resource_group_name` will be used."
#   default     = null
#   type        = string
# }

# variable "public_ip_address_id" {
#   description = "ID of a Public IP resource to associate with the NAT Gateway. Only for newly created resources."
#   default     = null
#   type        = string
# }

# variable "nat_gateway_id" {
#   description = "ID of a NAT Gateway resource to associate with the Public IP resource. Only for newly created resources."
#   default     = null
#   type        = string  
# }

# variable "public_ip_prefix" {
#   description = "ID of a Public IP Prefix resource to associate with the NAT Gateway. Only for newly created resources."
#   default     = null
#   type        = string
# }

variable "create_natgw" {
  description = <<-EOF
  Triggers creation of a NAT Gateway when set to `true`.
  
  Set it to `false` to source an existing resource. In this 'mode' the module will only bind an existing NAT Gateway to specified subnets.
  EOF
  default     = true
  type        = bool
}

variable "create_pip" {
  description = <<-EOF
  Set `true` to create a Public IP resource that will be connected to newly created NAT Gateway. Not used when NAT Gateway is only sourced.

  Setting this property to `false` has two meanings:
  * when `existing_pip_name` is `null` simply no Public IP will be created
  * when `existing_pip_name` is set to a name of an exiting Public IP resource it will be sourced and associated to this NAT Gateway.
  EOF
  default     = true
  type        = bool
}

variable "natgtw_name" {
  description = "Name of a NAT Gateway."
  type        = string
}

variable "pip_name" {
  description = "Name of a Public IP resource that will be created and associated with the NAT Gateway. Only for newly created resources."
  type        = string
}
  
variable "location" {
  description = "Azure region. Only for newly created resources."
  type        = string
}
variable "resource_group_name" {
  description = "Name of a Resource Group hosting the NAT Gateway (either the existing one or the one that will be created)."
  type        = string
}
variable "subnet_id" {
  description = "A map of subnet IDs what will be bound with this NAT Gateway. Value is the subnet ID, key value does not matter but should be unique, typically it can be a subnet name."
  default = ""
}
variable "public_ip_address_id" {
  description = "ID of a Public IP resource to associate with the NAT Gateway. Only for newly created resources."
  default = ""
}
variable "idle_timeout_in_minutes" {
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes."
  type        = number
  default     = null

  validation {
    condition     = (try(var.idle_timeout_in_minutes, false) == true ? (var.idle_timeout_in_minutes.value >= 4 || var.idle_timeout_in_minutes.value <= 30) : true)
    error_message = "Provide an allowed value as defined in https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway#idle_timeout_in_minutes."
  }
}

variable "zones" {
  description = "A list of Availability Zones which should be used for the NatGW. If not set, the NatGW will be created without an Availability Zone."
  default     = null
  type        = list(string)
}

variable "tags" {
  description = "(Optional) Tags for the resource to be deployed."
  default     = null
  type        = map(any)
}

