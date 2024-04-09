#---------------------------------------------------------
# Get/import Subscription details
#----------------------------------------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                            = lower("${var.key_vault_name}-kv")
  location                        = var.location 
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = try(var.key_vault_sku_pricing_tier, "standard")
  tags                            = try(var.tags, {})
  enabled_for_deployment          = try(var.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.enabled_for_template_deployment, false)
  purge_protection_enabled        = try(var.enable_purge_protection, false)
  soft_delete_retention_days      = try(var.soft_delete_retention_days, 7)
  enable_rbac_authorization       = try(var.enable_rbac_authorization, false)
  timeouts {
    delete = "60m"

  }

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []

    content {
      bypass         = var.network_acls.bypass
      default_action = try(var.network_acls.default_action, "Deny")
      ip_rules       = try(var.network_acls.ip_rules, null)
      virtual_network_subnet_ids = try(var.network_acls.subnets, null) == null ? null : [
        for key, value in var.network_acls.subnets : can(value.subnet_id)
      ]
    }
  }

  dynamic "access_policy" {
    for_each = local.service_principal_object_id != "" ? [local.self_permissions] : []
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = access_policy.value.object_id
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }

  lifecycle {
    ignore_changes = [
      resource_group_name, location
    ]
  }
}

