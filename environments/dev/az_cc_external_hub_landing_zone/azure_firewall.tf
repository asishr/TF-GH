# # Create Firewall Public IP.

# module "fw_public_ip_01" {
#   source = "../modules/networking/public_ip"
#   for_each               = var.locations
#   public_ips = [{
#     name                 = "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP01"
#     location             = each.value.name
#     resource_group_name  = module.resource_group_pa_vn[each.key].name
#     virtual_network_name = module.exthub-vnet[each.key].name
#     allocation_method    = "Static"
#     sku                  = "Standard"
#   }]
# }

# module "fw_public_ip_02" {
#   source = "../modules/networking/public_ip"
#   for_each               = var.locations
#   public_ips = [{
#     name                 = "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP02"
#     location             = each.value.name
#     resource_group_name  = module.resource_group_pa_vn[each.key].name
#     virtual_network_name = module.exthub-vnet[each.key].name
#     allocation_method    = "Static"
#     sku                  = "Standard"
#   }]
# }

# module "firewall_policy" {
#   source              = "../modules/networking/firewall_policy"
#   for_each            = var.locations
#   name                = "AFWP${each.value.alias}${var.environment}CTRXFW"
#   resource_group_name = module.resource_group_pa_vn[each.key].name
#   location            = each.value.name
#   depends_on          = [module.exthub-vnet]
#   rule_collection_group = [{
#     name     = "DefaultDnatRuleCollectionGroup"
#     priority = "100"
#     },
#     {
#       name     = "DefaultNetworkRuleCollectionGroup"
#       priority = "200"
#     },
#     {
#       name     = "DefaultApplicationRuleCollectionGroup"
#       priority = "300"
#     },
#     {
#       name     = "ALLOW-CITRIX-ADC-T1-IN"
#       priority = "500"
#       nat_rule_collection = [{
#         action   = "Dnat"
#         name     = "ALLOW-CITRIX-ADC-T1-IN"
#         priority = 500
#         rule = [{
#           destination_address = lookup(lookup(module.fw_public_ip_01[each.key].public_ip, "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP01"), "ip_address")
#           destination_ports   = ["443"]
#           name                = "ALLOW-AZCC.IGMSERVICES.CA-IN"
#           protocols           = ["TCP"]
#           source_addresses    = ["*"]
#           source_ip_groups    = []
#           translated_address  = "10.9.33.11",
#           translated_port     = 443
#           },
#           {
#             destination_address = lookup(lookup(module.fw_public_ip_02[each.key].public_ip, "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP02"), "ip_address")
#             destination_ports   = ["443"]
#             name                = "ALLOW-2884.IGMSERVICES.CA-IN"
#             protocols           = ["TCP"]
#             source_addresses    = ["*"]
#             source_ip_groups    = []
#             translated_address  = "10.9.33.10",
#             translated_port     = 443
#         }]
#       }]
#       network_rule_collection = [{
#         action   = "Allow"
#         name     = "ALLOW-CITRIX-ADC-T1-IN-NETWORK"
#         priority = 1000
#         rule = [{
#           destination_addresses = ["10.9.33.11"]
#           destination_fqdns     = []
#           destination_ports     = ["443"]
#           destination_ip_groups = []
#           name                  = "ALLOW-IGMSERVICES.CA-IN"
#           protocols             = ["TCP"]
#           source_addresses      = ["*"]
#           source_ip_groups      = []
#           },
#           {
#             destination_addresses = ["10.9.33.10"]
#             destination_fqdns     = []
#             destination_ports     = ["443"]
#             destination_ip_groups = []
#             name                  = "ALLOW-2884.IGMSERVICES.CA-IN"
#             protocols             = ["TCP"]
#             source_addresses      = ["*"]
#             source_ip_groups      = []
#         }]
#       }]
#     },
#     {
#       name     = "DENY-ALL"
#       priority = "65000"
#       network_rule_collection = [{
#         action   = "Deny"
#         name     = "DENY-ALL"
#         priority = 65000
#         rule = [{
#           destination_addresses = ["*"]
#           destination_fqdns     = []
#           destination_ports     = ["*"]
#           destination_ip_groups = []
#           name                  = "DENY-ALL"
#           protocols             = ["Any"]
#           source_addresses      = ["*"]
#           source_ip_groups      = []
#         }]
#       }]
#   }]
# }

# module "firewall" {
#   source              = "../modules/networking/firewall"
#   for_each            = var.locations
#   name                = "AFW-${each.value.alias}-${var.environment}-EXTHUB-CTRX-01"
#   resource_group_name = module.resource_group_pa_vn[each.key].name
#   location            = each.value.name
#   sku_name            = "AZFW_VNet"
#   sku_tier            = "Standard"
#   firewall_policy_id  = module.firewall_policy[each.key].id
#   ip_configuration = [
#     {
#       name                 = "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP01"
#       subnet_id            = lookup(module.exthub-vnet[each.key].subnet_ids, "AzureFirewallSubnet", null)
#       public_ip_address_id = lookup(lookup(module.fw_public_ip_01[each.key].public_ip, "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP01"), "id")
#   },
#   {
#       name                 = "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP02"
#       public_ip_address_id = lookup(lookup(module.fw_public_ip_02[each.key].public_ip, "AFW-${each.value.alias}-${var.business_unit}-${var.environment}-EXTHUB-UNTRUST-01-PIP02"), "id")
#   },
#   ]
#   depends_on = [module.firewall_policy]
# }

