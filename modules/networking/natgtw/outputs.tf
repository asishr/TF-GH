# output "natgw_pip" {
#   value = try(local.pip.ip_address, null)
# }

# output "natgw_pip_prefix" {
#   value = try(local.pip_prefix.ip_prefix, null)
# }


output "resource_guid" {
    value       = [for natguid in azurerm_nat_gateway.nat_gateway : natguid.resource_guid]
    description = "The resource GUID property of the NAT Gateway."
}


output "id" {
    value       = [for natid in azurerm_nat_gateway.nat_gateway : natid.id]
    description = "The ID of the NAT Gateway."
}

output "natgw_pip" {
    description = "Value of the NAT Gateway Public IP Address"
    value = [for pipid in azurerm_public_ip.natgtw_pip: pipid.id]
}

