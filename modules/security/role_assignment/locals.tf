locals {
  oids = { for pname, pnamedata in merge(data.azuread_user.user, data.azuread_group.group, data.azuread_service_principal.service_principal) : pname => pnamedata.id }
  rbac_assignements = { for item in flatten([
    [for role_name, assignments in var.role_assignments : [
      for assignment in assignments : {
        role_definition_name = role_name
        principal_name       = try(assignment["user_name"], assignment["group_name"], assignment["serviceprincipal_name"])
        principal_id         = lookup(assignment, "principal_id", lookup(local.oids, try(assignment["user_name"], assignment["group_name"], assignment["serviceprincipal_name"]), ""))
        skip_aad_check       = lookup(assignment, "skip_aad_check", null)
        description          = lookup(assignment, "description", null)
        condition            = lookup(assignment, "condition", null)
        condition_version    = lookup(assignment, "condition_version", null)
        timeouts             = lookup(assignment, "timeouts", null)

      }
      ]
  ]]) : format("%s_%s", item.role_definition_name, item.principal_name) => item }
}