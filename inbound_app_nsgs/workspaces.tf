provider "azurerm" {
  features {}
}

## Creating Terraform Cloud Workspaces
module "workspace" {
  source                  = "../modules/workspaces"
  for_each                =   { for each in var.workspaces : each.name=> each }
    workspace_name      = each.value.name
    organization_name   = each.value.org_name
    tags                = each.value.tags
    vcs_repo_identifier = each.value.vcs_repo_identifier
    vcs_repo_branch     = each.value.vcs_repo_branchcd 
    tf_oauth_client_id  = each.value.oauth_client_id
    working_directory   = each.value.working_directory
    variables           = lookup(each.value, "variables", [])
    force_delete        = lookup(each.value, "force_delete", true)
}

# resource "tfe_workspace_variable_set" "ws_var_set" {
#   for_each        =   { for each in var.workspaces : each.name=> each }
#   variable_set_id = data.tfe_variable_set.var_set.id
#   workspace_id    = module.workspace[each.key].id
# }

# resource "tfe_variable_set" "variable_set" {
#   name         = "Global_Set"
#   description  = "Variable set applied to all workspaces."
#   global       = true
#   organization = var.organization_name
# }

# resource "tfe_variable" "variable" {
#     for_each        = { for var in var.variables : var.key => var }
#     key             = each.value.key
#     value           = each.value.value
#     sensitive       = lookup(each.value, "sensitive", false)
#     category        = lookup(each.value, "category", "env")
#     description     = lookup(each.value, "description", null)
#     variable_set_id = tfe_variable_set.variable_set.id
# }