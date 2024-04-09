resource "azurerm_management_group" "parent_management_group" {
    count = var.deploy_mgmt_groups ? 1 : 0
        display_name      = var.management_groups.root.name
}

resource "azurerm_management_group" "children" {
    for_each                      = var.deploy_mgmt_groups ? var.management_groups.root.children : {}
        parent_management_group_id  = azurerm_management_group.parent_management_group[0].id
        display_name                = each.value.name 
        subscription_ids            = each.value.subscriptions
}