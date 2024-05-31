#-------------------------------
# Local Declarations
#-------------------------------
locals {
 storage_account = var.create_storage_account ? azurerm_storage_account.storeacc[0] : data.azurerm_storage_account.storeacc[0]
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