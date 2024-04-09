# Network security group for VMSS Management Network Interface
module "network_mgmt_security_rule" {
  source                 = "../modules/networking/network_security_group"
  for_each               = var.locations
  name                   = "AZ${each.value.alias}${var.environment}PAFW-MGMT-NIC01-NSG"
  location               = each.value.name
  resource_group_name    = module.resource_group_exthub[each.key].name
  network_security_rules = each.value.mgmt_network_security_rules
  depends_on             = [module.exthub-vnet]
}

# Network security group for VMSS Untrusted Network Interface
module "network_public_security_rule" {
  source                 = "../modules/networking/network_security_group"
  for_each               = var.locations
  name                   = "AZ${each.value.alias}${var.environment}PAFW-UNTRUST-NIC02-NSG"
  location               = each.value.name
  resource_group_name    = module.resource_group_exthub[each.key].name
  network_security_rules = each.value.untrust_network_security_rules
  depends_on             = [module.exthub-vnet]
}

module "law" {
    source                  = "../modules/log_analytics"
    for_each                = var.locations
    location                = each.value.name
    law_name                = "AZ${each.value.alias}${var.environment}INTPAFW-Law"
    resource_group_name     = module.resource_group_exthub[each.key].name
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
  resource_group_name                       = module.resource_group_exthub[each.key].name
  location                                  = each.value.name
  workspace_id                              = module.law[each.key].law_id
  tags                                      = var.tags
}

# Create File Share and put there files for initial boot of inbound VM-Series.
module "inbound_bootstrap" {
  source = "../modules/common/bootstrap"
  for_each             = var.locations
  resource_group_name  = module.resource_group_exthub[each.key].name
  location             = each.value.name
  storage_share_name   = var.inbound_storage_share_name
  storage_account_name = var.storage_account_name
  files                = var.inbound_files
}

# # Create File Share and put there files for initial boot of outbound VM-Series.
module "outbound_bootstrap" {
  source = "../modules/common/bootstrap"
  for_each               = var.locations
  resource_group_name    = module.resource_group_exthub[each.key].name
  create_storage_account = false
  storage_account_name   = module.inbound_bootstrap[each.key].storage_account.name
  storage_share_name     = var.outbound_storage_share_name
  files                  = var.outbound_files
  depends_on             = [module.inbound_bootstrap]
}

# Palo Alto Firewall appliances linux virtual machine scale set
module "vmss_scale_set" {
  source = "../modules/compute/linux_vmss"
  for_each                        = var.locations
  vmscaleset_name                 = "AZ${each.value.alias}${var.environment}EXTPAFW"
  location                        = each.value.name
  resource_group_name             = module.resource_group_exthub[each.key].name
  admin_username                  = var.username
  admin_password                  = coalesce(var.pswd, random_password.this.result)
  instances                       = 2
  public_key                     = local.first_public_key
  plan = {
    publisher                    = var.common_vmseries_publisher
    name                         = var.common_vmseries_sku
    product                      = var.common_vmseries_offer
  }
  source_image_reference = {
    publisher                     = var.common_vmseries_publisher
    offer                         = var.common_vmseries_offer
    sku                           = var.common_vmseries_sku
    version                       = var.common_vmseries_version
  }

  os_disk = {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface = [{
    name                          = "MGMT"
    primary                       = true
    enable_ip_forwarding          = true
    enable_accelerated_networking = false
    network_security_group_id     = module.network_mgmt_security_rule[each.key].id
    ip_configuration = [{
      primary                     = true
      subnet_id                   = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-MGMT-01"]
    }]
  },
  {
    name                          = "UNTRUST" 
    primary                       = false
    enable_ip_forwarding          = true
    enable_accelerated_networking = false
    network_security_group_id     = module.network_public_security_rule[each.key].id
    ip_configuration = [{
      name                        = var.name_public_nic_ip
      primary                     = true
      subnet_id                   = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01"]
      load_balancer_backend_address_pool_ids = module.untrust_lb[each.key].backend_pool_id
      public_ip_address = [{
        name                    = "AZ${each.value.alias}PPEXTPAFW02-UNTRUST-01-PIP"
        idle_timeout_in_minutes = 4
      }]
    }]
  },
  {
    name                          = "TRUST"  
    primary                       = false
    enable_ip_forwarding          = true
    enable_accelerated_networking = false

    ip_configuration = [{
      name                        = var.name_private_nic_ip
      primary                     = true
      subnet_id                   = module.exthub-vnet[each.key].subnet_ids["SNET-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-TRUST-01"]
      load_balancer_backend_address_pool_ids = module.trust_lb[each.key].backend_pool_id
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
