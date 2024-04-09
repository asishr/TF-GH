# Required parameters;
variable "name" {
  description = "name of the resource group"
  type        = string
}

variable "location" {
  description = "the Azure Region where the resource group should exist (eg. canadaeast)."
  type        = string
}

# Optional parameters;

variable "tags" {
  description = "An override to specify tags which will be added to the resoruce_group."
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  description = "identities and roles mapping ."
  type        = any
  default     = {}
}
