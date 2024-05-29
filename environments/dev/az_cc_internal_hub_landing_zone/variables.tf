variable "locations" {
  description = "The Azure region to use."
  default     = {}
  type        = any
}

variable "environment" {
  description = "The Environment to deploy."
  default     = "PRD"
  type        = string
}

variable "tags" {
  description = "Azure tags to apply to the created cloud resources. A map, for example `{ team = \"NetAdmin\", costcenter = \"CIO42\" }`"
  default     = {}
  type        = map(string)
}

variable "trust_lb_private_ip" {
  description = "Private IP of Frontend Trust LB"
  default     = null
  type        = string
}

variable "bu" {
  description = "The Environment to deploy."
  default     = "IGMF-CS"
  type        = string
}


variable "common_vmseries_sku" {
  description = "VM-Series SKU - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "byol"
  type        = string
}

variable "common_vmseries_version" {
  description = "VM-series PAN-OS version - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "10.1.5"
  type        = string
}

variable "common_vmseries_publisher" {
  description = "The Azure Publisher identifier for a image which should be deployed."
  type        = string
  default     = "paloaltonetworks"
}

variable "common_vmseries_offer" {
  description = "The Azure Offer identifier corresponding to a published image. For `img_version` 9.1.1 or above, use \"vmseries-flex\"; for 9.1.0 or below use \"vmseries1\"."
  type        = string
  default     = "vmseries-flex"
}

variable "proximity_placement_group_id" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "scale_in_policy" {
  description = <<-EOF
  Which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Either:

  - `Default`, which, baring the availability zone usage and fault domain usage, deletes VM with the highest-numbered instance id,
  - `NewestVM`, which, baring the availability zone usage, deletes VM with the newest creation time,
  - `OldestVM`, which, baring the availability zone usage, deletes VM with the oldest creation time.
  EOF
  default     = null
  type        = string
}

variable "scale_in_force_deletion" {
  description = "When set to `true` will force delete machines selected for removal by the `scale_in_policy`."
  default     = false
  type        = bool
  nullable    = false
}

variable "capacity_reservation_group_id" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "application_insights" {
  description = <<-EOF
  A map defining Azure Application Insights. There are three ways to use this variable:

  * when the value is set to `null` (default) no AI is created
  * when the value is a map containing `name` key (other keys are optional) a single AI instance will be created under the name that is the value of the `name` key
  * when the value is an empty map or a map w/o the `name` key, an AI instance per each VMSeries VM will be created. All instances will share the same configuration. All instances will have names corresponding to their VM name.

  Names for all AI instances are prefixed with `var.name_prefix`.

  Properties supported (for details on each property see [modules documentation](../../modules/application_insights/README.md)):

  - `name` : (optional, string) a name of a single AI instance
  - `workspace_mode` : (optional, bool) defaults to `true`, use AI Workspace mode instead of the Classical (deprecated)
  - `workspace_name` : (optional, string) defaults to AI name suffixed with `-wrkspc`, name of the Log Analytics Workspace created when AI is deployed in Workspace mode
  - `workspace_sku` : (optional, string) defaults to PerGB2018, SKU used by WAL, see module documentation for details
  - `metrics_retention_in_days` : (optional, number) defaults to current Azure default value, see module documentation for details

  Example of an AIs created per VM, in Workspace mode, with metrics retention set to 1 year:
  ```
  vmseries = {
    'vm-1' = {
      ....
    }
    'vm-2' = {
      ....
    }
  }

  application_insights = {
    metrics_retention_in_days = 365
  }
  ```
  EOF
  default     = null
  type        = map(string)
}

variable "autoscale_metrics" {
  description = " metrics and thresholds used to trigger scaling events, see module documentation for details"
  default     = {}
  type        = map(string) 
}


variable "count_default" {
  description = "default number or instances when autoscalling is not available"
  default     = null
  type = number

}
 variable "count_minimum" {
  description = "minimum number or instances when when scaling out"
  default     = null
  type      = number
 }

variable "count_maximum" {
  description = "maximum number or instances when when scaling out"
  default     = null
  type      = number

}

variable "notification_emails" {
  description = "a list of e-mail addresses to notify about scaling events"
  default     = null
  type        = list(string)
}

variable "scaleout_config" {
  description = "scale out configuration, for details see module documentation"
  default = {}
  type        = map(string)
}

variable "statistic" {
  description = "aggregation method for statistics coming from different VMs"
  default     = null
  type        = string
}

variable "time_aggregation" {
  description = "aggregation method applied to statistics in time window"
  default     = null
  type        = string
}

variable "window_minutes" {
  description = "time windows used to analyze statistics"
  default     = null
  type        = string
}

variable "cooldown_minutes" {
  description = "time to wait after a scaling event before analyzing the statistics again"
  default     = null
  type        = string
}

variable "scalein_config" {
  description = "scale in configuration, same properties supported as for `scaleout_config`"
  default     = {}
  type        = map(string)
}

variable "law_sku" {
  type        = string
  description = "The sku of the log analytics workspace"
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "The number of days for retention, between 7 and 730"
  default     = 90
}

variable "ampls_name" {
  description = "(Required) The name of the Azure Monitor Private Link Scope."
  type = string
}

variable "ampls_link_name" {
  description = "(Required) Specifies the name of this Private Link Service."
  type = string
}

variable "create_new_workspace" {
  type        = bool
  description = "Whether or not you wish to create a new workspace, if set to true, a new one will be created, if set to false, a data read will be performed on a data source"
}

variable "storage_account_name" {
  description = <<-EOF
  Default name of the storage account to create.
  The name you choose must be unique across Azure. The name also must be between 3 and 24 characters in length, and may include only numbers and lowercase letters.
  EOF
  type        = string
}

variable "inbound_storage_share_name" {
  description = "Name of storage share to be created that holds `files` for bootstrapping inbound VM-Series."
  type        = string
}

variable "outbound_storage_share_name" {
  description = "Name of storage share to be created that holds `files` for bootstrapping outbound VM-Series."
  type        = string
}

variable "inbound_files" {
  description = "Map of all files to copy to `inbound_storage_share_name`. The keys are local paths, the values are remote paths. Always use slash `/` as directory separator (unix-like), not the backslash `\\`. For example `{\"dir/my.txt\" = \"config/init-cfg.txt\"}`"
  default     = {}
  type        = map(string)
}

variable "outbound_files" {
  description = "Map of all files to copy to `outbound_storage_share_name`. The keys are local paths, the values are remote paths. Always use slash `/` as directory separator (unix-like), not the backslash `\\`. For example `{\"dir/my.txt\" = \"config/init-cfg.txt\"}`"
  default     = {}
  type        = map(string)
}