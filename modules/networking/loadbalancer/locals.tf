# locals {
#   # Decide how the backend machines access internet. If outbound rules are defined use them instead of the default route.
#   # This is an inbound rule setting, applicable to all inbound rules.
#   disable_outbound_snat = length(var.outbound_rules) > 0

#   # Recalculate the main input map, taking into account whether the boolean condition is true/false.
#   frontend_ips = {
#     for k, v in var.frontend_ips : k => {
#       name  = k
#       rules = try(v.rules, {})
#     }
#   }

#   # A list of all rules: outbound and inbound
#   all_rules = merge(var.frontend_ips, var.outbound_rules)

#   # Frontend ip configurations, no rules, only PIPs.
#   # The `if` statement is to avoid errors in LB configuration when re-using a PIP created by some other rule.
#   frontend_ip_configurations = {
#     for k, v in local.all_rules : k => {
#       name                          = k
#       public_ip_address_id          = try(v.create_public_ip, false) ? azurerm_public_ip.this[k].id : try(data.azurerm_public_ip.exists[k].id, null)
#       create_public_ip              = try(v.create_public_ip, false)
#       zones                         = try(v.zones, null)
#       subnet_id                     = try(v.subnet_id, null)
#       private_ip_address_allocation = try(v.private_ip_address_allocation, null)
#       private_ip_address            = try(v.private_ip_address, null)
#     }
#     if try(v.create_public_ip, false) || !can(local.all_rules[v.public_ip_name])
#   }

#   # Terraform for_each unfortunately requires a single-dimensional map, but we have
#   # a two-dimensional input. We need two steps for conversion.

#   # Firstly, flatten() ensures that this local value is a flat list of objects, rather
#   # than a list of lists of objects.
#   input_flat_rules = flatten([
#     for fipkey, fip in local.frontend_ips : [
#       for rulekey, rule in fip.rules : {
#         fipkey  = fipkey
#         fip     = fip
#         rulekey = rulekey
#         rule    = rule
#       }
#     ]
#   ])

#   # Finally, convert flat list to a flat map. Make sure the keys are unique. This is used for for_each.
#   input_rules = { for v in local.input_flat_rules : "${v.fipkey}-${v.rulekey}" => v }

#   # Now, the outputs to be returned by the module. First, calculate the raw IP addresses.
#   output_ips = { for _, v in azurerm_lb.lb.frontend_ip_configuration : v.name => try(data.azurerm_public_ip.exists[v.name].ip_address, azurerm_public_ip.this[v.name].ip_address, v.private_ip_address) }

#   # A more rich output combines the raw IP addresses with more attributes.
#   # As the later NSGs demand that troublesome numerical `priority` attribute, we
#   # need to generate unique numerical `index`. So, lets use keys() for that:
#   # output_rules = {
#   #   for i, k in keys(local.input_rules) : k => {
#   #     index        = i
#   #     fipkey       = local.input_rules[k].fipkey
#   #     rulekey      = local.input_rules[k].rulekey
#   #     port         = local.input_rules[k].rule.port
#   #     nsg_priority = lookup(local.input_rules[k].rule, "nsg_priority", null)
#   #     protocol     = lower(local.input_rules[k].rule.protocol)
#   #     frontend_ip  = local.output_ips[local.input_rules[k].fipkey]
#   #     // The hash16 is 16-bit in size, just crudely yank the initial digits of sha256.
#   #     hash16 = parseint(substr(sha256("${local.output_ips[local.input_rules[k].fipkey]}:${local.input_rules[k].rule.port}"), 0, 4), 16)
#   #   }
#   # }
# }