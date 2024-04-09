# # Network Interface for Virtual Machine

resource "azurerm_network_interface" "nic" {
    count                           = var.instances_count
    name                            = format("%s%02s", var.nic_name, count.index + 1)
    location                        = var.location
    resource_group_name             = var.resource_group_name
    dns_servers                     = var.dns_servers
    enable_ip_forwarding            = var.enable_ip_forwarding
    enable_accelerated_networking   = var.enable_accelerated_networking
    internal_dns_name_label         = var.internal_dns_name_label
    tags                            = var.tags

  ip_configuration {
    name                            = format("%s%02s", var.config_name, count.index + 1)
    primary                         = true
    subnet_id                       = var.subnet_id
    private_ip_address_allocation   = var.private_ip_address_allocation_type
    private_ip_address              = var.private_ip_address_allocation_type == "Static" ? element(concat(var.private_ip_address, [""]), count.index) : null
    public_ip_address_id            = var.enable_public_ip_address == true ? var.public_ip : null
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_network_interface_security_group_association" "nsgassoc" {
    count                           = var.instances_count
    network_interface_id            = element(concat(azurerm_network_interface.nic.*.id, [""]), count.index)
    network_security_group_id       = var.network_security_group_id
}

# # Windows Virutal machine
resource "azurerm_windows_virtual_machine" "windows_vm" {
    count                    = var.instances_count
    name                     = format("%s%02s", var.virtual_machine_name, count.index + 1)
    resource_group_name      = var.resource_group_name
    location                 = var.location
    network_interface_ids    = [element(concat(azurerm_network_interface.nic.*.id, [""]), count.index)]
    license_type             = var.license_type
    patch_mode               = var.patch_mode
    enable_automatic_updates = var.enable_automatic_updates
    computer_name            = format("%s%02s", var.virtual_machine_name, count.index + 1)
    admin_username           = var.admin_username
    admin_password           = var.admin_password
    size                     = var.virtual_machine_size
    source_image_id          = var.source_image_id != null ? var.source_image_id : null
    zone                     = var.vm_availability_zone
    timezone                 = var.timezone
    encryption_at_host_enabled = var.enable_encryption_at_host
    allow_extension_operations = var.allow_extension_operations
    provision_vm_agent         = var.provision_vm_agent

    dynamic "source_image_reference" {
        for_each = var.source_image_id != null ? [] : [1]
        content {
            publisher = try(var.image_reference_publisher, null)
            offer     = try(var.image_reference_offer, null)
            sku       = try(var.image_reference_sku, null)
            version   = try(var.image_reference_version, null)
            }
        }

    dynamic "plan" {
        for_each = var.enable_plan ? ["one"] : []
        content {
            name      = try(var.image_reference_sku, null)
            publisher = try(var.image_reference_publisher, null)
            product   = try(var.image_reference_offer, null)
        }
    }

   

    dynamic "identity" {
        for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
        content {
        type = var.identity_type
        }
    }

    dynamic "identity" {
        for_each = var.managed_identity_type != null ? [1] : []
        content {
            type         = var.managed_identity_type
            identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
        }
    }

    priority        = var.spot_instance ? "Spot" : "Regular"
    max_bid_price   = var.spot_instance ? var.spot_instance_max_bid_price : null
    eviction_policy = var.spot_instance ? var.spot_instance_eviction_policy : null

    os_disk {
        name                 =  (format("%s%02s-OSDISK",var.virtual_machine_name, count.index+1))
        caching              = "ReadWrite"
        storage_account_type = var.os_disk_storage_account_type
        disk_size_gb         = var.disk_size_gb
    }

    dynamic "boot_diagnostics" {
        for_each = var.enable_boot_diagnostics ? [1] : []
        content {
        storage_account_uri = var.storage_account_name != null ? var.storage_account_uri : null
        }
    }

    tags = var.tags
}

# # Virtual machine data disks

resource "azurerm_managed_disk" "data_disk" {
    for_each             = local.vm_data_disks
    name                 = (format("%s%02s-OSDISK",var.virtual_machine_name, each.value.idx+1))
    resource_group_name  = var.resource_group_name
    location             = var.location
    storage_account_type = lookup(each.value.data_disk, "storage_account_type", "StandardSSD_LRS")
    create_option        = "Empty"
    disk_size_gb         = each.value.data_disk.disk_size_gb
    tags                 = var.tags

    lifecycle {
        ignore_changes = [
        tags,
        ]
    }
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
    for_each           = local.vm_data_disks
    managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
    virtual_machine_id = azurerm_windows_virtual_machine.windows_vm[0].id
    lun                = each.value.idx
    caching            = "ReadWrite"
}
