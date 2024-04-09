
data "azuread_user" "user" {
  for_each = { for item in setunion(flatten([for role_name, assignments in var.role_assignments : [
    for assignment in assignments : {
      principal_name = lookup(assignment, "user_name", null)
    } if contains(keys(assignment), "user_name") && !contains(keys(assignment), "principal_id")
  ]])) : item.principal_name => item }
  user_principal_name = format("%s", each.key)
}

data "azuread_group" "group" {
  for_each = { for item in setunion(flatten([for role_name, assignments in var.role_assignments : [
    for assignment in assignments : {
      principal_name = lookup(assignment, "group_name", null)
    } if contains(keys(assignment), "group_name") && !contains(keys(assignment), "principal_id")
  ]])) : item.principal_name => item }
  display_name = format("%s", each.key)
}

data "azuread_service_principal" "service_principal" {
  for_each = { for item in setunion(flatten([for role_name, assignments in var.role_assignments : [
    for assignment in assignments : {
      principal_name = lookup(assignment, "serviceprincipal_name", null)
    } if contains(keys(assignment), "serviceprincipal_name") && !contains(keys(assignment), "principal_id")
  ]])) : item.principal_name => item }
  display_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each                         = local.rbac_assignements
  scope                            = var.scope
  role_definition_name             = each.value.role_definition_name
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = each.value.skip_aad_check
  description                      = each.value.description
  condition                        = each.value.condition
  condition_version                = each.value.condition_version


  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = lookup(timeouts, "create", null)
      delete = lookup(timeouts, "delete", null)
      read   = lookup(timeouts, "read", null)
      update = lookup(timeouts, "update", null)
    }
  }
}



