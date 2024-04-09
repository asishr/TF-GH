resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku

  dynamic "ip_configuration" {
    for_each = length(var.ip_configuration) > 0 ? [var.ip_configuration] : []
    content {
      name                          = lookup(var.ip_configuration, "type", null)
      public_ip_address_id          = lookup(var.ip_configuration, "public_ip_address_id", null)
      private_ip_address_allocation = lookup(var.ip_configuration, "private_ip_address_allocation", null)
      subnet_id                     = lookup(var.ip_configuration, "subnet_id", null)
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = length(var.vpn_client_configuration) > 0 ? [var.vpn_client_configuration] : []
    content {
      address_space = vpn_client_configuration.value.address_space

      dynamic "root_certificate" {
        for_each = lookup(vpn_client_configuration.value, "root_certificate", null) == null ? [] : [vpn_client_configuration.value.root_certificate]
        content {
          name             = lookup(root_certificate.value, "name", null)
          public_cert_data = lookup(root_certificate.value, "public_cert_data", null)
        }
      }

      dynamic "revoked_certificate" {
        for_each = lookup(vpn_client_configuration.value, "revoked_certificate", null) == null ? [] : [vpn_client_configuration.value.revoked_certificate]
        content {
          name       = lookup(revoked_certificate.value, "name", [])
          thumbprint = lookup(revoked_certificate.value, "thumbprint", null)
        }
      }
    }
  }
}