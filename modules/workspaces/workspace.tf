resource "tfe_workspace" "workspace" {
    name                = var.workspace_name
    organization        = var.organization_name
    tag_names           = var.tags
    auto_apply          = var.auto_apply
    force_delete        = var.force_delete
    #project_id          = var.project_id
    working_directory   = var.working_directory

    vcs_repo {
        identifier = var.vcs_repo_identifier
        oauth_token_id = var.tf_oauth_client_id
        ingress_submodules = true
        branch = var.vcs_repo_branch
    }
}

resource "tfe_variable" "variable" {
    for_each        = { for var in var.variables : var.key => var }
    key             = each.value.key
    value           = each.value.value
    sensitive       = lookup(each.value, "sensitive", false)
    category        = lookup(each.value, "category", "env")
    description     = lookup(each.value, "description", null)
    workspace_id    = tfe_workspace.workspace.id
}
