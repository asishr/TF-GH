
variable "management_groups" {
  type = any
  description = "(Required) Gets the map of management groups and attached subscriptions."
}

variable "deploy_mgmt_groups" {
  type = bool
  description = "(Required) Toggle to enable management group deployment."
}

variable "tags" {
  type        = map(string)
  description = "Key/value pairs of tags that will be applied to all resources in this module."
}