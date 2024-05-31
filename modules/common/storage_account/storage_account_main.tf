terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"

    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.22.0"
    }
  }
}

# module "azuread_recommended_provider_version" {
#   source = "../../../tools/required_providers/v1/azuread"
# }

# module "azurerm_recommended_provider_version" {
#   source = "../../../tools/required_providers/v1/azurerm"
# }

# module "common_resource_tags" {
#   source                = "../../../tools/resource_tags/v1"
#   module_name           = "storage_account"
#   module_version        = "1.0.2"
#   environment_variables = var.environment_variables
#   custom_tags           = var.custom_tags
#   tags                  = var.tags
# }

resource "azurerm_storage_account" "storage_account" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  enable_https_traffic_only         = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  # tags                              = module.common_resource_tags.tags
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  edge_zone                         = var.edge_zone
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type

  dynamic "azure_files_authentication" {
    for_each = length(keys(var.azure_files_authentication)) > 0 ? [var.azure_files_authentication] : []
    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = length(keys(lookup(var.azure_files_authentication, "active_directory", {}))) > 0 ? [var.azure_files_authentication.active_directory] : []
        content {
          storage_sid         = active_directory.value.storage_sid         # (Required) Specifies the security identifier (SID) for Azure Storage.
          domain_name         = active_directory.value.domain_name         # (Required) Specifies the primary domain that the AD DNS server is authoritative for.
          domain_sid          = active_directory.value.domain_sid          # (Required) Specifies the security identifier (SID).
          domain_guid         = active_directory.value.domain_guid         # (Required) Specifies the domain GUID.
          forest_name         = active_directory.value.forest_name         # (Required) Specifies the Active Directory forest.        
          netbios_domain_name = active_directory.value.netbios_domain_name # (Required) Specifies the NetBIOS domain name.
        }
      }
    }
  }

  dynamic "routing" {
    for_each = length(keys(var.routing)) > 0 ? [var.routing] : []
    content {
      publish_internet_endpoints  = lookup(routing.value, "publish_internet_endpoints", null)
      publish_microsoft_endpoints = lookup(routing.value, "publish_microsoft_endpoints", null)
      choice                      = lookup(routing.value, "choice", null)
    }
  }

  dynamic "custom_domain" {
    for_each = length(keys(var.custom_domain)) > 0 ? [var.custom_domain] : []
    content {
      name          = custom_domain.value.domain_name
      use_subdomain = lookup(custom_domain.value, "use_subdomain", null)
    }
  }

  dynamic "customer_managed_key" {
    for_each = length(keys(var.customer_managed_key)) > 0 ? [var.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  dynamic "identity" {
    for_each = length(keys(var.identity)) > 0 ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "blob_properties" {
    for_each = length(keys(var.blob_properties)) > 0 ? [var.blob_properties] : []
    content {
      versioning_enabled            = lookup(var.blob_properties, "versioning_enabled", null)
      change_feed_enabled           = lookup(var.blob_properties, "change_feed_enabled", null)
      change_feed_retention_in_days = lookup(var.blob_properties, "change_feed_retention_in_days", null)
      default_service_version       = lookup(var.blob_properties, "default_service_version", null)
      last_access_time_enabled      = lookup(var.blob_properties, "last_access_time_enabled", null)

      dynamic "cors_rule" {
        for_each = length(keys(lookup(var.blob_properties, "cors_rule", {}))) > 0 ? [var.blob_properties.cors_rule] : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = length(keys(lookup(var.blob_properties, "delete_retention_policy", {}))) > 0 ? [var.blob_properties.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = length(keys(lookup(var.blob_properties, "container_delete_retention_policy", {}))) > 0 ? [var.blob_properties.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = length(keys(var.queue_properties)) > 0 ? [var.queue_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = length(keys(lookup(var.queue_properties, "cors_rule", {}))) > 0 ? [var.queue_properties.cors_rule] : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = length(keys(lookup(var.queue_properties, "logging", {}))) > 0 ? [var.queue_properties.logging] : []
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          version               = logging.value.version
          write                 = logging.value.write
          retention_policy_days = lookup(logging.value, "retention_policy_days", null)
        }
      }

      dynamic "minute_metrics" {
        for_each = length(keys(lookup(var.queue_properties, "minute_metrics", {}))) > 0 ? [var.queue_properties.minute_metrics] : []
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = lookup(minute_metrics.value, "include_apis", null)
          retention_policy_days = lookup(minute_metrics.value, "retention_policy_days", null)
        }
      }

      dynamic "hour_metrics" {
        for_each = length(keys(lookup(var.queue_properties, "hour_metrics", {}))) > 0 ? [var.queue_properties.hour_metrics] : []
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = lookup(hour_metrics.value, "include_apis", null)
          retention_policy_days = lookup(hour_metrics.value, "retention_policy_days", null)
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = length(keys(var.share_properties)) > 0 ? [var.share_properties] : []
    content {
      dynamic "cors_rule" {
        for_each = length(keys(lookup(var.share_properties, "cors_rule", {}))) > 0 ? [var.share_properties.cors_rule] : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = length(keys(lookup(var.share_properties, "retention_policy", {}))) > 0 ? [var.share_properties.retention_policy] : []
        content {
          days = retention_policy.value.days
        }
      }

      dynamic "smb" {
        for_each = length(keys(lookup(var.share_properties, "smb", {}))) > 0 ? [var.share_properties.smb] : []
        content {
          versions                        = smb.value.versions                        # (Optional) A set of SMB protocol versions. Possible values are SMB2.1, SMB3.0, and SMB3.1.1.
          authentication_types            = smb.value.authentication_types            # (Optional) A set of SMB authentication methods. Possible values are NTLMv2, and Kerberos.
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type # (Optional) A set of Kerberos ticket encryption. Possible values are RC4-HMAC, and AES-256.
          channel_encryption_type         = smb.value.channel_encryption_type         # (Optional) A set of SMB channel encryption. Possible values are AES-128-CCM, AES-128-GCM, and AES-256-GCM.
          multichannel_enabled            = smb.value.multichannel_enabled            # (Optional) Indicates whether multichannel is enabled. Defaults to false. This is only supported on Premium storage accounts.          
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = length(keys(var.static_website)) > 0 ? [var.static_website] : []
    content {
      index_document     = lookup(static_website.value, "index_document", null)
      error_404_document = lookup(static_website.value, "error_404_document", null)
    }
  }

  dynamic "network_rules" {
    for_each = [local.default_network_rules]
    content {
      default_action             = network_rules.value.default_action # Security hardening; R_2.11
      bypass                     = network_rules.value.bypass
      # ip_rules                   = network_rules.value.ip_rules
      # virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = length(keys(lookup(network_rules.value, "private_link_access", {}))) > 0 ? [network_rules.value.private_link_access] : []
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }
}

resource "azurerm_storage_container" "blob_container" {
  for_each              = { for container in var.containers : container.name => container }
  name                  = each.value.name
  container_access_type = lookup(each.value, "container_access_type", null)
  metadata              = lookup(each.value, "metadata", null)
  storage_account_name  = azurerm_storage_account.storage_account.name
}

locals {
  default_acls = [
    { permissions = "---", scope = "access", type = "other" },
    { permissions = "---", scope = "default", type = "other" },
    { permissions = "r-x", scope = "access", type = "group" },
    { permissions = "r-x", scope = "access", type = "mask" },
    { permissions = "r-x", scope = "default", type = "group" },
    { permissions = "rwx", scope = "access", type = "user" },
    { permissions = "rwx", scope = "default", type = "mask" },
    { permissions = "rwx", scope = "default", type = "user" }
  ]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gen2_filesystem" {
  for_each           = { for filesystem in var.adls_gen2 : filesystem.name => filesystem }
  name               = each.value.name
  storage_account_id = azurerm_storage_account.storage_account.id
  properties         = lookup(each.value, "properties", null)
  owner              = lookup(each.value, "owner", null)
  group              = lookup(each.value, "group", null)

  dynamic "ace" {
    for_each = length(lookup(each.value, "ace", [])) > 0 ? flatten([[local.default_acls], [each.value.ace]]) : flatten([[local.default_acls]])
    content {
      scope       = lookup(ace.value, "scope")
      type        = ace.value.type
      id          = lookup(ace.value, "id", null)
      permissions = ace.value.permissions
    }
  }
}

resource "azurerm_storage_data_lake_gen2_path" "gen2_path" {
  for_each = { for path in flatten(
    [for filesystem in var.adls_gen2 :
    [for b in lookup(filesystem, "gen2_path", []) : merge(b, { filesystem_name = filesystem.name })]]) :
  format("%s_%s", path.filesystem_name, path.path) => path }
  path               = each.value.path
  filesystem_name    = each.value.filesystem_name
  storage_account_id = azurerm_storage_account.storage_account.id
  resource           = "directory"
  owner              = lookup(each.value, "owner", null)
  group              = lookup(each.value, "group", null)

  dynamic "ace" {
    for_each = length(lookup(each.value, "ace", [])) > 0 ? flatten([[local.default_acls], [each.value.ace]]) : flatten([[local.default_acls]])
    content {
      scope       = lookup(ace.value, "scope")
      type        = ace.value.type
      id          = lookup(ace.value, "id", null)
      permissions = ace.value.permissions
    }
  }

  depends_on = [
    azurerm_storage_data_lake_gen2_filesystem.gen2_filesystem
  ]
}

resource "azurerm_storage_blob" "blob_storage" {
  for_each               = { for blob in flatten([for container in var.containers : [for b in lookup(container, "blobs", []) : merge(b, { container_name = container.name })]]) : blob.name => blob }
  name                   = each.value.name
  type                   = each.value.type
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = each.value.container_name
  size                   = lookup(each.value, "size", null)
  access_tier            = lookup(each.value, "access_tier", null)
  content_type           = lookup(each.value, "content_type", null)
  source                 = lookup(each.value, "source", null)
  source_content         = lookup(each.value, "source_content", null)
  source_uri             = lookup(each.value, "source_uri", null)
  parallelism            = lookup(each.value, "parallelism", null)
  metadata               = lookup(each.value, "metadata", null)
  cache_control          = lookup(each.value, "cache_control", null)
  content_md5            = lookup(each.value, "content_md5", null)

  depends_on = [
    azurerm_storage_container.blob_container
  ]
}

resource "azurerm_storage_share" "storage_share" {
  for_each             = { for share in var.shares : share.name => share }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = each.value.quota
  metadata             = lookup(each.value, "metadata", null)
  access_tier          = lookup(each.value, "access_tier", null)
  enabled_protocol     = lookup(each.value, "enabled_protocol", null)

  dynamic "acl" {
    for_each = lookup(each.value, "acl", [])
    content {
      id = acl.value.id
      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access_policy.start
        expiry      = acl.value.access_policy.expiry
      }
    }
  }
}

resource "azurerm_storage_share_directory" "storage_share_directory" {
  for_each = { for directory in flatten([for share in var.shares :
    [for dirs in lookup(share, "directories", []) :
      [for path in dirs.name : {
        name       = path
        share_name = share.name
        metadata   = lookup(dirs, "metadata", null)
      }]
    ]
  ]) : directory.name => directory }

  name                 = each.value.name
  share_name           = each.value.share_name
  metadata             = lookup(each.value, "metadata", null)
  storage_account_name = azurerm_storage_account.storage_account.name
  depends_on = [
    azurerm_storage_share.storage_share
  ]
}

resource "azurerm_storage_table" "storage_table" {
  for_each             = { for table in var.tables : table.name => table }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name

  dynamic "acl" {
    for_each = lookup(each.value, "acl", [])
    content {
      id = acl.value.id
      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access_policy.start
        expiry      = acl.value.access_policy.expiry
      }
    }
  }
}

resource "azurerm_storage_queue" "storage_queue" {
  for_each             = { for queue in var.queues : queue.name => queue }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
  metadata             = lookup(each.value, "metadata", null)

  #  ** NOTE ** : ACL for storage queue not supported by terraform 
  #dynamic "acl" {
  #    for_each = lookup(each.value, "acl" , []) 
  #    content {
  #        id = acl.value.id
  #        access_policy {
  #            permissions = acl.value.access_policy.permissions 
  #            start       = acl.value.access_policy.start 
  #            expiry      = acl.value.access_policy.expiry 
  #        }
  #    }
  #}
}

resource "azurerm_storage_account_customer_managed_key" "storage_encryption" {
  count                     = var.encryption_type == "CustomManaged" ? 1 : 0
  storage_account_id        = azurerm_storage_account.storage_account.id
  key_vault_id              = var.key_vault_id
  key_name                  = var.key_name
  key_version               = var.key_version
  user_assigned_identity_id = var.user_assigned_identity_id
}

resource "azurerm_storage_sync" "storage_sync" {
  for_each                = { for share in var.shares : share.name => share if(lookup(share, "enable_share_sync", false)) }
  name                    = format("sync-%s-%s", azurerm_storage_account.storage_account.name, each.key)
  resource_group_name     = var.resource_group_name
  location                = var.location
  incoming_traffic_policy = lookup(each.value, "incoming_traffic_policy", null) #  Possible values are AllowAllTraffic and AllowVirtualNetworksOnly. When set to AllowVirtualNetworksOnly, it uses a private endpoint linked to "Microsoft.StorageSync/storagesyncServices" and subresource "Afs".
  # tags                    = module.common_resource_tags.tags
}

resource "azurerm_storage_sync_group" "sync_group" {
  for_each        = { for share in var.shares : share.name => share if(lookup(share, "enable_share_sync", false)) }
  name            = format("syncGroup-%s-%s", azurerm_storage_account.storage_account.name, each.key)
  storage_sync_id = azurerm_storage_sync.storage_sync[each.key].id
}

resource "azurerm_storage_sync_cloud_endpoint" "sync_cloud_endpoint" {
  for_each              = { for share in var.shares : share.name => share if(lookup(share, "enable_share_sync", false)) }
  name                  = format("cloudEndpoint-%s-%s", azurerm_storage_account.storage_account.name, each.key)
  storage_sync_group_id = azurerm_storage_sync_group.sync_group[each.key].id
  file_share_name       = each.key
  storage_account_id    = azurerm_storage_account.storage_account.id
  # depends_on            = [module.role_assignments]
}

resource "azurerm_storage_management_policy" "management_policy" {
  count              = (var.lifecycle_rules == [] || var.lifecycle_rules == null) ? 0 : 1
  storage_account_id = azurerm_storage_account.storage_account.id

  dynamic "rule" {
    for_each = { for lifecycle_rule in var.lifecycle_rules : lifecycle_rule.name => lifecycle_rule }
    content {
      name    = rule.value.name
      enabled = lookup(rule.value, "enabled", false)

      dynamic "filters" {
        for_each = lookup(rule.value, "filters", [])
        content {
          prefix_match = lookup(filters.value, "prefix_match", [])
          blob_types   = lookup(filters.value, "blob_types", [])

          dynamic "match_blob_index_tag" {
            for_each = { for match_blob_index_tag in lookup(filters.value, "match_blob_index_tags", []) : match_blob_index_tag.share_name => match_blob_index_tag }
            content {
              name      = match_blob_index_tag.value.name
              operation = match_blob_index_tag.value.operation
              value     = match_blob_index_tag.value.value
            }
          }
        }
      }

      actions {
        dynamic "base_blob" {
          for_each = { for base_blob in lookup(rule.value.actions, "base_blob", {}) == {} ? {} : { "base_blob" = rule.value.actions.base_blob } : "base_blob" => base_blob }
          content {
            tier_to_cool_after_days_since_modification_greater_than        = lookup(base_blob.value, "tier_to_cool_after_days_since_modification_greater_than", null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = lookup(base_blob.value, "tier_to_cool_after_days_since_last_access_time_greater_than", null)
            tier_to_archive_after_days_since_modification_greater_than     = lookup(base_blob.value, "tier_to_archive_after_days_since_modification_greater_than", null)
            tier_to_archive_after_days_since_last_access_time_greater_than = lookup(base_blob.value, "tier_to_archive_after_days_since_last_access_time_greater_than", null)
            delete_after_days_since_modification_greater_than              = lookup(base_blob.value, "delete_after_days_since_modification_greater_than", null)
            delete_after_days_since_last_access_time_greater_than          = lookup(base_blob.value, "delete_after_days_since_last_access_time_greater_than", null)
          }
        }

        dynamic "snapshot" {
          for_each = { for snapshot in lookup(rule.value.actions, "snapshot", {}) == {} ? {} : { "snapshot" = rule.value.actions.snapshot } : "snapshot" => snapshot }
          content {
            change_tier_to_cool_after_days_since_creation    = lookup(snapshot.value, "change_tier_to_cool_after_days_since_creation", null)
            change_tier_to_archive_after_days_since_creation = lookup(snapshot.value, "change_tier_to_archive_after_days_since_creation", null)
            delete_after_days_since_creation_greater_than    = lookup(snapshot.value, "delete_after_days_since_creation_greater_than", null)
          }
        }

        dynamic "version" {
          for_each = { for version in lookup(rule.value.actions, "version", {}) == {} ? {} : { "version" = rule.value.actions.version } : "version" => version }
          content {
            change_tier_to_cool_after_days_since_creation    = lookup(version.value, "change_tier_to_cool_after_days_since_creation", null)
            change_tier_to_archive_after_days_since_creation = lookup(version.value, "change_tier_to_archive_after_days_since_creation", null)
            delete_after_days_since_creation                 = lookup(version.value, "delete_after_days_since_creation", null)
          }
        }
      }
    }
  }
}

locals {
  # for FileShare Sync : role assignement required to enable Filesync 
  is_sync_enabled = length(keys({ for share in var.shares : share.name => share if(lookup(share, "enable_share_sync", false)) })) > 0 ? true : false

  # can be overriden  by end user by submitting this role for storage account 
  roles_to_add_for_sync = tomap({ "Reader and Data Access" = [{
    serviceprincipal_name = "Microsoft.StorageSync"
    principal_id          = "399489b0-b591-4470-9c8e-394bc090020a"
    skip_aad_check        = false
    }]
  })

  role_assignment_sa = merge(var.role_assignments, { for k in keys(local.roles_to_add_for_sync) : k => setunion(lookup(var.role_assignments, k, []), local.roles_to_add_for_sync[k]) })

  flattened_data = { for item in flatten([
    [{ scope_id        = azurerm_storage_account.storage_account.id
      roles_identities = local.is_sync_enabled == true ? tomap(local.role_assignment_sa) : tomap(var.role_assignments)
      scope_name       = format("account_%s", var.name)
    }],
    [for container in var.containers : flatten([
      [for blob in lookup(container, "blobs", []) : {
        scope_name       = format("blob_%s-%s", container.name, blob.name)
        roles_identities = lookup(blob, "role_assignments", {})
        scope_id         = format("%s/blobs/%s", azurerm_storage_container.blob_container[container.name].resource_manager_id, blob.name)
      }],
      [{
        scope_name       = format("container_%s", container.name, )
        roles_identities = lookup(container, "role_assignments", {})
        scope_id         = azurerm_storage_container.blob_container[container.name].resource_manager_id
      }]
    ])],
    [for share in var.shares : flatten([
      [for directory in lookup(share, "directories", []) :
        [for path in directory.name : {
          scope_name       = format("directory_%s-%s", share.name, path)
          roles_identities = lookup(directory, "role_assignments", {})
          scope_id         = format("%s/directory/%s", azurerm_storage_share.storage_share[share.name].resource_manager_id, path)
        }]
      ],
      [{ scope_name      = format("share_%s", share.name)
        roles_identities = lookup(share, "role_assignments", {})
        scope_id         = azurerm_storage_share.storage_share[share.name].resource_manager_id

      }]
      ])
    ],
    [for filesystem in var.adls_gen2 : {
      scope_name       = format("filesystem_%s", filesystem.name)
      roles_identities = lookup(filesystem, "role_assignments", {})
      scope_id         = format("%s/blobServices/default/containers/%s", azurerm_storage_account.storage_account.id, filesystem.name)

      }
    ],
    [for queue in var.queues : {
      scope_name       = format("queue_%s", queue.name)
      roles_identities = lookup(queue, "role_assignments", {})
      scope_id         = format("%s/queueServices/default/queues/%s", azurerm_storage_account.storage_account.id, queue.name)

      }
    ],
    [for table in var.tables : {
      scope_name       = format("table_%s", table.name)
      roles_identities = lookup(table, "role_assignments", {})
      scope_id         = format("%s/tableServices/default/tables/%s", azurerm_storage_account.storage_account.id, table.name)

      }
    ]
  ]) : item.scope_name => item }

  storage_assignments = { for item in local.flattened_data : item.scope_name => item if length(keys(lookup(item, "roles_identities", {}))) != 0 }

  storage_diagnostics_settings = [for tp in setunion(flatten([for setting in var.diagnostic_settings : setting.target_types])) : {
    diagnostic_scope_id = tp == "storage" ? azurerm_storage_account.storage_account.id : format("%s/%sServices/default", azurerm_storage_account.storage_account.id, tp)
    scope_name          = format("%s", tp)
    diagnostic_settings = [for setting in var.diagnostic_settings :
    merge({ for k, v in setting : k => v if k != "target_types" }, tomap({ "name" : format("%s-%s", setting.name, tp) })) if contains(lookup(setting, "target_types", []), tp)]
  }]

  default_network_rules = {
    default_action             = lookup(var.network_rules, "default_action", "Deny")
    bypass                     = lookup(var.network_rules, "bypass", ["AzureServices"])
    # ip_rules                   = flatten([module.default_firewall.allowed.ip_address, lookup(var.network_rules, "ip_rules", [])])
    # virtual_network_subnet_ids = flatten([module.default_firewall.allowed.subnets, lookup(var.network_rules, "virtual_network_subnet_ids", [])])
  }
}

# module "default_firewall" {
#   source                = "../../../tools/default_network_firewall/v1/"
#   location              = var.location
#   core_services     = lookup(var.network_rules, "core_services", [])
#   enable_zscaler_lookup = var.enable_zscaler_lookup
#   module_name           = module.common_resource_tags.module_name
# }

# module "storage_monitor_diagnostic" {
#   source              = "../../../management_tools/monitor_diagnostic/v1"
#   for_each            = { for diagnostic_setting in local.storage_diagnostics_settings : diagnostic_setting.scope_name => diagnostic_setting }
#   target_resource_id  = each.value.diagnostic_scope_id
#   diagnostic_settings = each.value.diagnostic_settings
# }

resource "azurerm_storage_blob_inventory_policy" "blob_inventory_policy" {
  for_each           = { for container in var.containers : container.name => container if length(lookup(container, "inventory_policy_rules", [])) != 0 }
  storage_account_id = azurerm_storage_account.storage_account.id

  dynamic "rules" {
    for_each = { for inventory in each.value.inventory_policy_rules : inventory.name => inventory }
    content {
      name                   = rules.value.name
      storage_container_name = each.value.name
      format                 = lookup(rules.value, "format", null)
      schedule               = lookup(rules.value, "schedule", null)
      scope                  = lookup(rules.value, "scope", null)
      schema_fields          = lookup(rules.value, "schema_fields", null)

      dynamic "filter" {
        for_each = length(keys(lookup(rules.value, "filter", {}))) > 0 ? [rules.value.filter] : []
        content {
          blob_types            = rules.value.filter.blob_types
          include_blob_versions = lookup(rules.value.filter, "include_blob_versions", null)
          include_snapshots     = lookup(rules.value.filter, "include_snapshots", null)
          prefix_match          = lookup(rules.value.filter, "prefix_match", null)
        }
      }
    }
  }
}

# module "private_endpoint" {
#   source              = "../../../networking/private_endpoint/v1"
#   for_each            = { for private_endpoint in var.private_endpoints : private_endpoint.name => private_endpoint }
#   name                = each.value.name
#   location            = lookup(each.value, "location", var.location)
#   resource_group_name = lookup(each.value, "resource_group_name", var.resource_group_name)
#   existing_subnet     = lookup(each.value, "existing_subnet", null)
#   subnet_id           = lookup(each.value, "subnet_id", null)
#   ip_configuration    = lookup(each.value, "ip_configuration", {})

#   private_service_connections = flatten(
#     [for connection in lookup(each.value, "private_service_connections", {}) : {
#       name                           = connection.name
#       private_connection_resource_id = azurerm_storage_account.storage_account.id
#       subresource_names              = connection.subresource_names
#       is_manual_connection           = lookup(connection, "is_manual_connection", false)
#       request_message                = lookup(connection, "request_message", null)
#   }])

#   private_dns_zone_groups = lookup(each.value, "private_dns_zone_groups", null)
#   tags                    = module.common_resource_tags.tags
# }
