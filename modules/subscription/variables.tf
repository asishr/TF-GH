#---------------------------------------
# REQUIRED INPUTS
#---------------------------------------
variable billing_account_name {
    type = string
    description = "The Billing Account Name of the MCA account."
}

variable billing_profile_name {
    type = string
    description = "The Billing Profile Name in the above Billing Account."
}

variable invoice_section_name {
    type = string
    description = "The Invoice Section Name in the above Billing Profile."
}

variable enrollment_account_name {
    type = string
    description = "The Enrollment Account Name in the above Enterprise Account."
}

variable subscription_name {
    type = string
    description = "The Name of the Subscription. This is the Display Name in the portal."
}

variable "tags" {
  type        = map(string)
  description = "Key/value pairs of tags that will be applied to all resources in this module."
}


#---------------------------------------
# OPTIONAL INPUTS
#---------------------------------------

variable "subscription_key" {
    type = number
    description = "Azure enrollment number and access key for Enterprise Agreement customers received when initially sign up for Azure."
    default = null
}

variable billing_scope_id {
    type = string
    description = "The Azure Billing Scope ID. Can be a Microsoft Customer Account Billing Scope ID, a Microsoft Partner Account Billing Scope ID or an Enrollment Billing Scope ID."
    default = null
}

variable subscription_id {
    type = string
    description = "The ID of the Subscription. Changing this forces a new Subscription to be created."
    default = null
}

variable workload {
    type = string
    description = "The workload type of the Subscription. Possible values are Production (default) and DevTest. Changing this forces a new Subscription to be created."
    default = "DevTest"
}

variable alias {
    type = string
    description = "The Alias name for the subscription. Terraform will generate a new GUID if this is not supplied. Changing this forces a new Subscription to be created."
    default = null
}


variable create_alias {
    type = any
    description = "Determines if an alias should be created for a specific subscription."
    default = {}
}

# For diagnostics settings
variable "diagnostics" {
    type = string
    description = "Specifies the name of the Diagnostic Setting."
    default = null
}