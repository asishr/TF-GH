resource "azurerm_linux_virtual_machine_scale_set" "virtual_machine_scale_set" {
  count                           = var.os_flavor == "linux" ? 1 : 0
  name                            = format("%s%02s", var.vmscaleset_name, count.index + 1)
  computer_name_prefix            = var.computer_name_prefix == null && var.instances_count == 1 ? substr(var.vmscaleset_name, 0, 15) : substr(format("%s%02s", var.vmscaleset_name, count.index + 1), 0, 15)
  location                        = var.location
  resource_group_name             = var.resource_group_name
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication == null ? true : false
  encryption_at_host_enabled      = var.encryption_at_host_enabled
  overprovision                   = var.overprovision
  platform_fault_domain_count     = var.platform_fault_domain_count
  proximity_placement_group_id    = var.proximity_placement_group_id
  scale_in_policy                 = var.scale_in_policy
  single_placement_group          = var.capacity_reservation_group_id == null ? true : false
  capacity_reservation_group_id   = var.capacity_reservation_group_id 
  instances                       = var.instances
  sku                             = var.sku
  tags                            = var.tags
  zones                           = var.zones
  zone_balance                    = var.zone_balance
  provision_vm_agent              = var.provision_vm_agent
  upgrade_mode                    = var.upgrade_mode
  custom_data                     = base64encode(var.bootstrap_options)

  admin_ssh_key {
    public_key  = var.public_key
    username    = var.admin_username
  }

  scale_in {
    rule                   = var.scale_in_policy
    force_deletion_enabled = var.scale_in_force_deletion
  }

  dynamic "network_interface" {
    for_each = [for v in var.network_interface : v if length(v) > 0]
    content {
      name                          = format("%s-%s%02s-NIC", var.vmscaleset_name, network_interface.value.name, count.index + 1)
      primary                       = lookup(network_interface.value, "primary", null)
      enable_ip_forwarding          = lookup(network_interface.value, "enable_ip_forwarding", null)
      enable_accelerated_networking = lookup(network_interface.value, "enable_accelerated_networking", null)
      dns_servers                   = lookup(network_interface.value, "dns_servers", [])
      network_security_group_id     = lookup(network_interface.value, "network_security_group_id", null)

      dynamic "ip_configuration" {
        for_each = lookup(network_interface.value, "ip_configuration", [])
        content {
          name      = lower("ipconfig-${format("%s%s", lower(replace(var.vmscaleset_name, "/[[:^alnum:]]/", "")), count.index + 1)}")
          primary   = lookup(ip_configuration.value, "primary", null)
          subnet_id = lookup(ip_configuration.value, "subnet_id", null)
          version = lookup(ip_configuration.value, "version", null) 
          application_gateway_backend_address_pool_ids = lookup(ip_configuration.value, "application_gateway_backend_address_pool_ids", null)
          application_security_group_ids = lookup(ip_configuration.value, "application_security_group_ids", null)
          load_balancer_backend_address_pool_ids = lookup(ip_configuration.value, "load_balancer_backend_address_pool_ids", null)
          load_balancer_inbound_nat_rules_ids = lookup(ip_configuration.value, "load_balancer_inbound_nat_rules_ids", null)
        
          dynamic "public_ip_address" {
            for_each = lookup(ip_configuration.value, "public_ip_address", [])
            content {
              name         = public_ip_address.value.name
              version      = lookup(public_ip_address.value, "version", null)
              public_ip_prefix_id = lookup(public_ip_address.value, "public_ip_prefix_id", null)
              domain_name_label = lookup(public_ip_address.value, "domain_name_label", null)
              idle_timeout_in_minutes = lookup(public_ip_address.value, "idle_timeout_in_minutes", null)

              dynamic "ip_tag" {
                for_each = lookup(ip_configuration.value, "ip_tag", [])
                content {
                  tag         = ip_tag.value.tag
                  type        = ip_tag.value.type
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "os_disk" {
    for_each = [for v in [var.os_disk] : v if length(v) > 0]
    content {
      caching                       = os_disk.value.caching
      storage_account_type          = os_disk.value.storage_account_type
      disk_encryption_set_id        = lookup(os_disk.value, "disk_encryption_set_id", null)
      disk_size_gb                  = lookup(os_disk.value, "disk_size_gb", null)
      security_encryption_type      = lookup(os_disk.value, "security_encryption_type", null)
      write_accelerator_enabled     = lookup(os_disk.value, "write_accelerator_enabled", null)
      secure_vm_disk_encryption_set_id = lookup(os_disk.value, "secure_vm_disk_encryption_set_id", null)

      dynamic "diff_disk_settings" {
        for_each = lookup(os_disk.value, "diff_disk_settings", [])
        content {
          option     = diff_disk_settings.value.option
          placement  = lookup(diff_disk_settings.value, "placement", null)
        }
      }
    }
  }

  dynamic "identity" {
    for_each = [for v in [var.identity] : v if length(v) > 0]
    content {
      type         = lookup(var.identity, "type", "SystemAssigned")
      identity_ids = lookup(var.identity, "identity_ids", null)
    }
  }

  dynamic "plan" {
    for_each = [for v in [var.plan] : v if length(v) > 0]
    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = [for v in [var.rolling_upgrade_policy] : v if length(v) > 0]
    content {
      cross_zone_upgrades_enabled      = lookup(rolling_upgrade_policy.value, "cross_zone_upgrades_enabled", null)
      max_batch_instance_percent       = lookup(rolling_upgrade_policy.value, "max_batch_instance_percent", null)
      max_unhealthy_instance_percent   = lookup(rolling_upgrade_policy.value, "max_unhealthy_instance_percent", null)
      pause_time_between_batches       = lookup(rolling_upgrade_policy.value, "pause_time_between_batches", null)
      prioritize_unhealthy_instances_enabled = lookup(rolling_upgrade_policy.value, "prioritize_unhealthy_instances_enabled", null)
      max_unhealthy_upgraded_instance_percent = lookup(rolling_upgrade_policy.value, "max_unhealthy_upgraded_instance_percent", null)
    }
  }

  dynamic "secret" {
    for_each = [for v in [var.secret] : v if length(v) > 0]
    content {
      key_vault_id = lookup(var.secret, "key_vault_id", null)

      dynamic "certificate" {
        for_each = lookup(secret.value, "certificate", [])
        content {
          url  = lookup(certificate.value, "url", null)
        }
      }
    }
  }

  dynamic "source_image_reference" {
    for_each = [for v in [var.source_image_reference] : v if length(v) > 0]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "spot_restore" {
    for_each = [for v in [var.spot_restore] : v if length(v) > 0]
    content {
      enabled = lookup(spot_restore.value, "enabled", null)
      timeout = lookup(spot_restore.value, "timeout", null)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = [for v in [var.boot_diagnostics] : v if length(v) > 0]
    content {
      storage_account_uri = lookup(boot_diagnostics.value, "storage_account_uri", null)
    }
  }

  dynamic "data_disk" {
    for_each = [for v in [var.data_disk] : v if length(v) > 0]
    content {
      name          = format("%s%s-OSDISK", var.vmscaleset_name, count.index + 1)
      caching       = lookup(data_disk.value, "caching", null)
      create_option = lookup(data_disk.value, "create_option", null)
      disk_size_gb  = lookup(data_disk.value, "disk_size_gb", null)
      lun           = lookup(data_disk.value, "lun", null)
      storage_account_type = lookup(data_disk.value, "storage_account_type", null)
      disk_encryption_set_id = lookup(data_disk.value, "disk_encryption_set_id", null)
      write_accelerator_enabled = lookup(data_disk.value, "disk_encryption_set_id", null)
    }
  }
}


## Create a Linux Virtual Machine Scale Set with Application Insights
resource "azurerm_monitor_autoscale_setting" "this" {
  count = length(var.autoscale_metrics) > 0 ? 1 : 0

  name                = "${var.vmscaleset_name}-autoscale"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.virtual_machine_scale_set[count.index].id

  profile {
    name = "autoscale profile"

    capacity {
      default = var.autoscale_count_default
      minimum = var.autoscale_count_minimum
      maximum = var.autoscale_count_maximum
    }

    dynamic "rule" {
      for_each = var.autoscale_metrics

      content {
        metric_trigger {
          metric_name        = rule.key
          metric_resource_id = rule.key == "Percentage CPU" ? azurerm_linux_virtual_machine_scale_set.virtual_machine_scale_set[count.index].id : var.application_insights_id
          metric_namespace   = "Azure.ApplicationInsights"
          operator           = "GreaterThanOrEqual"
          threshold          = rule.value.scaleout_threshold

          statistic        = var.scaleout_statistic
          time_aggregation = var.scaleout_time_aggregation
          time_grain       = "PT1M" # PT1M means: Period of Time 1 Minute
          time_window      = local.scaleout_window
        }

        scale_action {
          direction = "Increase"
          value     = "1"
          type      = "ChangeCount"
          cooldown  = local.scaleout_cooldown
        }
      }
    }

    dynamic "rule" {
      for_each = var.autoscale_metrics

      content {
        metric_trigger {
          metric_name        = rule.key
          metric_resource_id = rule.key == "Percentage CPU" ? azurerm_linux_virtual_machine_scale_set.virtual_machine_scale_set[count.index].id : var.application_insights_id
          metric_namespace   = "Azure.ApplicationInsights"
          operator           = "LessThanOrEqual"
          threshold          = rule.value.scalein_threshold

          statistic        = var.scalein_statistic
          time_aggregation = var.scalein_time_aggregation
          time_grain       = "PT1M"
          time_window      = local.scalein_window
        }

        scale_action {
          direction = "Decrease"
          value     = "1"
          type      = "ChangeCount"
          cooldown  = local.scalein_cooldown
        }
      }
    }
  }

  notification {
    email {
      custom_emails = var.autoscale_notification_emails
    }
    dynamic "webhook" {
      for_each = var.autoscale_webhooks_uris

      content {
        service_uri = webhook.value
      }
    }
  }

  tags = var.tags
}
