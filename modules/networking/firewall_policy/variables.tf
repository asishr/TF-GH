variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Firewall Policy"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the Firewall Policy should exist."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Firewall Policy should exist."
}

variable "sku" {
  type = string
  description = "(Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium and Basic."
  default = null
}

variable "private_ip_ranges" {
  type = any #list(string)
  description = "(Optional) A list of private IP ranges to which traffic will not be SNAT."
  default = null#[]
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "base_policy_id" {
  description = "(Optional) The ID of the base Firewall Policy."
  type        = string
  default     = null
}

variable "dns" {
  description = "(Optional) A dns block"
  type        = map(string)
  default     = {}
}

variable "identity" {
  description = " (Optional) An identity block"
  type        = map(string)
  default     = {}
}

variable "insights" {
  description = "(Optional) An insights block"
  type        = map(string)
  default     = {}
}

variable "intrusion_detection" {
  description = "(Optional) A intrusion_detection block"
  type        = map(string)
  default     = {}
}

variable "threat_intelligence_allowlist" {
  description = "(Optional) A threat_intelligence_allowlist block"
  type        = map(string)
  default     = {}
}

variable "threat_intelligence_mode" {
  description = "(Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert."
  type        = string
  default     = null
}

variable "tls_certificate" {
  description = "(Optional) A tls_certificate block"
  type        = map(string)
  default     = {}
}

variable "sql_redirect_allowed" {
  description = "(Optional) Whether SQL Redirect traffic filtering is allowed. Enabling this flag requires no rule using ports between 11000-11999."
  type        = string
  default     = null
}

variable "rule_collection_group" {
  description = "(Required) The name which should be used for this Firewall Policy Rule Collection Group."
  type = any
  default = []
}

# variable "firewall_policy_id" {
#   description = "(Required) The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist."
#   type = string
# }

variable "priority" {
  description = "(Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000."
  type = number
  default = null
}

variable "network_rule_collection" {
  description = "(Optional) One or more firewall policy rule collection blocks."
  type    = any
  default = []
}

variable "application_rule_collection" {
  description = "(Optional) One or more application_rule_collection blocks."
  type    = any
  default = []
}

variable "nat_rule_collection" {
  description = "(Optional) One or more firewall policy nat rule collection blocks."
  type    = any
  default = []
}
