#-------------------------------
# Local Declarations
#-------------------------------
locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])
  private_endpoint_resources = merge(
    {
      datafactory = false
      keyvault    = false
      blob        = true
      file        = true
    },
    {
      for resource in var.private_endpoint_resources_enabled :
        lower(resource) => true
    }
  )
}