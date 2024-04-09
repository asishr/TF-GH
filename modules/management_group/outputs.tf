output "name" {
  value = azurerm_management_group.parent_management_group.*.name
  description = "Management Group name."
}

output "id" {
  value = azurerm_management_group.parent_management_group.*.id
  description = "The ID of the Management Groups"
}

output "rootmgid" {
  value = azurerm_management_group.parent_management_group.*.id
  description = "The ID of the Parent Management Group."
}