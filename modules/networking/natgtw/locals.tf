
# locals {
#   natgw_id = var.create_natgw ? azurerm_nat_gateway.natgtw[0].id : data.azurerm_nat_gateway.this[0].id

#   pip = var.create_natgw ? (
#     var.create_pip ? azurerm_public_ip.pip[0] : try(data.azurerm_public_ip.this[0], null)
#   ) : null

#   pip_prefix = var.create_natgw ? (
#     var.create_pip_prefix ? azurerm_public_ip_prefix.pip[0] : try(data.azurerm_public_ip_prefix.this[0], null)
#   ) : null
# }