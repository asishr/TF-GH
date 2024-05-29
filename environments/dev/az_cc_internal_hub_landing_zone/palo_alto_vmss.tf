module "random_password" {
  source           = "../modules/common/password_generator"
}

locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}

module "law" {
    source                  = "../modules/log_analytics"
    for_each                = var.locations
    location                = each.value.name
    law_name                = "AZ${each.value.alias}${var.environment}INTPAFW-Law"
    resource_group_name     = module.resource_group[each.key].name
    retention_in_days       = var.retention_in_days
    law_sku                 = var.law_sku
    ampls_link_name         = var.ampls_link_name
    ampls_name              = var.ampls_name
    create_new_workspace    = var.create_new_workspace
    tags                    = var.tags
}

module "ai" {
  source = "../modules/app_insights"
  for_each                                  = var.locations
  appinsights_name                          = "AZ${each.value.alias}${var.environment}INTPAFW-AppInsights"
  resource_group_name                       = module.resource_group[each.key].name
  location                                  = each.value.name
  workspace_id                              = module.law[each.key].law_id
  tags                                      = var.tags
}

# Create File Share and put there files for initial boot of inbound VM-Series.
module "inbound_bootstrap" {
  source = "../modules/common/bootstrap"
  for_each             = var.locations
  resource_group_name  = module.resource_group[each.key].name
  location             = each.value.name
  storage_share_name   = var.inbound_storage_share_name
  storage_account_name = var.storage_account_name
  files                = var.inbound_files
}

# # Create File Share and put there files for initial boot of outbound VM-Series.
module "outbound_bootstrap" {
  source = "../modules/common/bootstrap"
  for_each               = var.locations
  resource_group_name    = module.resource_group[each.key].name
  create_storage_account = false
  storage_account_name   = module.inbound_bootstrap[each.key].storage_account.name
  storage_share_name     = var.outbound_storage_share_name
  files                  = var.outbound_files
  depends_on             = [module.inbound_bootstrap]
}

module "vmss_scale_set" {
    source = "../modules/compute/linux_vmss"
    for_each                                = var.locations
    vmscaleset_name                         = "AZ${each.value.alias}${var.environment}INTPAFW"
    resource_group_name                     = module.resource_group[each.key].name
    location                                = each.value.name
    admin_username                          = "adminuser"
    admin_password                          = module.random_password.password
    public_key                              = local.first_public_key
    instances                               = 2
    proximity_placement_group_id            = var.proximity_placement_group_id
    scale_in_policy                         = var.scale_in_policy
    scale_in_force_deletion                 = var.scale_in_force_deletion
    capacity_reservation_group_id           = var.capacity_reservation_group_id

    source_image_reference = {
        publisher                           = var.common_vmseries_publisher
        offer                               = var.common_vmseries_offer
        sku                                 = var.common_vmseries_sku
        version                             = var.common_vmseries_version
    }

    plan = {
        publisher                           = var.common_vmseries_publisher
        name                                = var.common_vmseries_sku
        product                             = var.common_vmseries_offer
    }

    os_disk = {
        storage_account_type                = "Standard_LRS"
        caching                             = "ReadWrite"
    }

    network_interface = [{
        name                                = "TRUST"
        primary                             = true
        enable_ip_forwarding                = true
        enable_accelerated_networking       = false

        ip_configuration = [{
            name                            = "ipconfig-trust"
            primary                         = true
            subnet_id                       = lookup(module.vnet[each.key].subnet_ids, "SNET-${each.value.alias}-${var.bu}-${var.environment}-INTHUB-TRUST-01", null) 
            load_balancer_backend_address_pool_ids = module.trust_lb[each.key].backend_pool_id

            public_ip_address = [{
                name                        = "AZ${each.value.alias}PPINTPAFW01-TRUST-01-PIP"
                idle_timeout_in_minutes     = 4
            }]
        }]
    }]

    bootstrap_options = (join(",",
        [
        "storage-account=${module.outbound_bootstrap[each.key].storage_account.name}",
        "access-key=${module.outbound_bootstrap[each.key].storage_account.primary_access_key}",
        "file-share=${module.outbound_bootstrap[each.key].storage_share.name}",
        "share-directory=None"
        ]
    ))

    application_insights_id = can(var.autoscale_metrics) ? module.ai[each.key].id : null

    ## Autoscale configuration
    autoscale_count_default         = try(var.count_default, null)
    autoscale_count_minimum         = try(var.count_minimum, null)
    autoscale_count_maximum         = try(var.count_maximum, null)
    autoscale_notification_emails   = try(var.notification_emails, null)
    autoscale_metrics               = try(var.autoscale_metrics, {})
    scaleout_statistic              = try(var.statistic, null)
    scaleout_time_aggregation       = try(var.time_aggregation, null)
    scaleout_window_minutes         = try(var.window_minutes, null)
    scaleout_cooldown_minutes       = try(var.cooldown_minutes, null)
    scalein_statistic               = try(var.statistic, null)
    scalein_time_aggregation        = try(var.time_aggregation, null)
    scalein_window_minutes          = try(var.window_minutes, null)
    scalein_cooldown_minutes        = try(var.cooldown_minutes, null)
}

output "pswd" {
    value = module.random_password.*.password
    sensitive = true
}
  
