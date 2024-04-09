output "windows_vm_public_ips" {
  description = "Public IP's map for the all windows Virtual Machines"
  value       = var.enable_public_ip_address == true ? zipmap(azurerm_windows_virtual_machine.windows_vm.*.name, azurerm_windows_virtual_machine.windows_vm.*.public_ip_address) : null
}

output "windows_vm_private_ips" {
  description = "Public IP's map for the all windows Virtual Machines"
  value       =  zipmap(azurerm_windows_virtual_machine.windows_vm.*.name,  azurerm_windows_virtual_machine.windows_vm.*.private_ip_address)
}

output "windows_virtual_machine_ids" {
  description = "The resource id's of all windows Virtual Machine."
  value       = azurerm_windows_virtual_machine.windows_vm.*.id
}