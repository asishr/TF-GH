variable "ARM_CLIENT_ID" {
  description = "ARM App"
  type        = string
  default     = null
}

variable "ARM_CLIENT_SECRET" {
  description = "ARM Sec"
  type        = string
  default     = null
}

variable "ARM_TENANT_ID" {
  description = "ARM Teanant"
  type        = string
  default     = null
}

variable "variables" {
    description = "ADO Pat"
    type        = any
    default     = {}
}

variable "oauth_token_name" {
  description = "ADO Pat"
  type        = string
  default     = null
}

variable "project_id" {
  description = "HashiCorp Cloud Project ID"
  type        = string
  default     = null
}

variable "organization_name" {
  description = "ARM Teanant"
  type        = string
  default     = null
}
variable "tf_oauth_client_id" {
  description = "Oauth Client ID"
  type        = string
  default     = null

}
variable "workspace_name" {
  description = "Name of workspace"
  type        = string
  default     = null
}

variable "working_directory" {
  description = "A relative path that Terraform will execute within. Defaults to the root of your repository"
  type        = string
  default     = null
  
}
variable "tags" {
  description = "ARM Teanant"
  type        = list(string)
  default = [""]
}

variable "auto_apply" {
  description = "ADO Pat"
  type        = string
  default = false
}

variable "force_delete" {
  description = "ADO Pat"
  type        = string
  default     = false
}

variable "vcs_repo_identifier" {
  description = "ADO Pat"
  type        = string
  default = false
}

variable "vcs_repo_branch" {
  description = "ADO Pat"
  type        = string
  default     = false
}
