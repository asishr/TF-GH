<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.28.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.variable](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.variable_set](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace.workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ARM_CLIENT_ID"></a> [ARM\_CLIENT\_ID](#input\_ARM\_CLIENT\_ID) | ARM App | `string` | `null` | no |
| <a name="input_ARM_CLIENT_SECRET"></a> [ARM\_CLIENT\_SECRET](#input\_ARM\_CLIENT\_SECRET) | ARM Sec | `string` | `null` | no |
| <a name="input_ARM_TENANT_ID"></a> [ARM\_TENANT\_ID](#input\_ARM\_TENANT\_ID) | ARM Teanant | `string` | `null` | no |
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | ADO Pat | `string` | `false` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | ADO Pat | `string` | `false` | no |
| <a name="input_oauth_token_name"></a> [oauth\_token\_name](#input\_oauth\_token\_name) | ADO Pat | `string` | `null` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | ARM Teanant | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | HashiCorp Cloud Project ID | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | ARM Teanant | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tf_oauth_client_id"></a> [tf\_oauth\_client\_id](#input\_tf\_oauth\_client\_id) | Oauth Client ID | `string` | n/a | yes |
| <a name="input_variables"></a> [variables](#input\_variables) | ADO Pat | `any` | <pre>[<br>  {<br>    "key": "ARM_TENANT_ID",<br>    "value": null<br>  },<br>  {<br>    "key": "ARM_CLIENT_SECRET",<br>    "value": null<br>  },<br>  {<br>    "key": "ARM_CLIENT_ID",<br>    "value": null<br>  }<br>]</pre> | no |
| <a name="input_vcs_repo_branch"></a> [vcs\_repo\_branch](#input\_vcs\_repo\_branch) | ADO Pat | `string` | `false` | no |
| <a name="input_vcs_repo_identifier"></a> [vcs\_repo\_identifier](#input\_vcs\_repo\_identifier) | ADO Pat | `string` | `false` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of workspace | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->