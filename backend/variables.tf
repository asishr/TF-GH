# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "Dev"
}
# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "Canada Central"
}
