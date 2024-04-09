# Role Assignment

This module creates a set of Role Assignments for Azure resources.

For details on role conditions, please see the Microsoft docs for [role assignment conditions](https://docs.microsoft.com/en-ca/azure/role-based-access-control/conditions-role-assignments-portal).

Important Notes:
* If authenticating using a Service Principal then it must have permissions to **Directory.ReadWrite.All** within the **Windows Azure Active Directory** API.
* If the principal_id is provided, `<type>_name` can either be `user_name` or `group_name`.
* If the principal_id is NOT provided, `<type>_name` is used as a key to perform a lookup to locate the `principal_id`.

<br />

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azuread | >= 2.9.0 |
| azurerm | >= 3.28.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| condition | role condition, for details see :https://docs.microsoft.com/en-ca/azure/role-based-access-control/conditions-role-assignments-portal | `string` | `null` | no |
| condition_version | role condition_version possible  value 1.0 or 2.0 | `string` | `null` | no |
| role_assignments | user and roles mapping | `any` | `{}` | no |
| scope | scope id of the target resource | `any` | `null` | no |
| skip_aad_check | flag used to enable principal id validation against active directory | `bool` | `false` | no |
| timeouts | timeout for create , read , delete andd update operations | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_assignment | n/a |

<br />

# Child Blocks and/or Modules

Some variables consist of blocks of key value pairs. This section of the README provides additional information on the structure of the child blocks.

<br />

<!-- END_TF_DOCS -->

## role_assignments
```bash
    scope            = any       # scope ID of the target resource.  this can be any Azure resource ID.
    role_assignments = {         # a map of roles, each role mapped to one or several identities (user, group and/or service principal)
       "<role_name>"   = [{      # role name (eg. Reader, Owner, ...)
            
          <type>_name       # (Required) <type> can be user, group or serviceprincipal
          principal_id      # (Optional) If provided, the value must be a valid ID  
          skip_aad_check    # (Optional) If the principal_id is a newly-provisioned service principal, set this value to true in order to skip the Azure Active Directory check (it may fail due to to true in order to skip the Azure Active Directory check (it may fail due to replication lag.  This argument is only valid if the principal_id is a service principal identity.  The role assignment will fail if it isn't a service principal identity.  Defaults to false.
          condition         # (Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.
          condition_version # (Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created.
          description       # (Optional) The description for this Role Assignment. Changing this forces a new resource to be created.
          timeouts        = {
                create      # (Optional) duration as a string ex "10m" or "2h"
                delete      # (Optional) duration as a string ex "20m" or "2h"
                read        # (Optional) duration as a string ex "30m" or "2h"
                update      # (Optional) duration as a string ex "40m" or "2h"
          }
       }]
    }
```
<br />

# Example
                    
The following is an example of inputs and outputs for role assignment on a storage account named "tfstatestorageac"
                    
<br />

## Input

```bash 
    scope_id  = "/subscriptions/836b8cd3-0110-4622-a835-5571ddc176e5/resourceGroups/Tfstate-RG/providers/Microsoft.Storage/storageAccounts/tfstatestorageac"
    role_assignments = {
      Owner = [{
        description    = "testing assignement of owner for asishracha "
        user_name      = "asishracha@microsoft.com"
        principal_id   = "1bb208f6-fb13-4786-bd8b-e477d83da0a9"
        skip_aad_check = false
        timeouts = {
          read = "30m"
        }
      }]
      Contributor = [{
        description           = "testing assignement of Contributor for SPN"
        serviceprincipal_name = "TFP-ARM-SPN"
        principal_id          = "3f9cd5ba-2c14-4c04-a78d-b01511029049"
        skip_aad_check        = true
      }]
```
<br />