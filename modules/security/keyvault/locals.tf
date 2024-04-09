#-------------------------------
# Local Declarations
#-------------------------------
locals {
  # resource_group_name      = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  # location                 = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  private_endpoint_resources = merge(
    {
      datafactory = false
      keyvault    = true
      blob        = false
    },
    {
      for resource in var.private_endpoint_resources_enabled :
        lower(resource) => true
    }
  )
  service_principal_object_id = data.azurerm_client_config.current.object_id
  azure_ad_service_principal_names = distinct(flatten(local.access_policies[*].azure_ad_service_principal_names))
  self_permissions = {
    object_id               = local.service_principal_object_id
    tenant_id               = data.azurerm_client_config.current.tenant_id
    key_permissions         = ["Create", "Delete", "Get", "Backup", "Decrypt", "Encrypt", "Import", "List", "Purge", "Recover", "Restore", "Sign", "Update", "Verify"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  }

   access_policies = [
    for p in var.access_policies : merge({
      azure_ad_group_names             = []
      object_ids                       = []
      azure_ad_user_principal_names    = []
      certificate_permissions          = []
      key_permissions                  = []
      secret_permissions               = []
      storage_permissions              = []
      azure_ad_service_principal_names = []
    }, p)
  ]
}