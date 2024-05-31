
variable "role_assignments" {
  description = "user and roles mapping"
  type        = any
  default     = {}
}

variable "scope" {
  description = "scope id of the target resource"
  type        = any
  default     = null
}

variable "skip_aad_check" {
  description = "flag used to enable principal id validation against active directory"
  type        = bool
  default     = false
}

variable "condition" {
  description = " role condition, for details see :https://docs.microsoft.com/en-ca/azure/role-based-access-control/conditions-role-assignments-portal"
  type        = string
  default     = null
}
variable "condition_version" {
  description = " role condition_version possible  value 1.0 or 2.0 "
  type        = string
  default     = null
}
variable "timeouts" {
  description = " timeout for create , read , delete andd update operations "
  type        = any
  default     = {}
}


