variable "location" {
  description = "Region to install VM-Series and dependencies."
  type        = string
}

variable "name_prefix"{
  description = "VM instance name prefix"
  type = any
  default = []
}

variable "resource_group_name" {
  description = "Name of the existing resource group where to place the resources created."
  type        = string
}

variable "instances_count" {
  description = "The number of Virtual Machines in the Scale Set."
  default     = 2
}

variable "vmscaleset_name" {
  description = "A prefix for all the names of the created Azure objects. It can end with a dash `-` character, if your naming convention prefers such separator."
  type        = string
}

variable "os_flavor" {
  description = "Specify the flavour of the operating system image to deploy VMSS. Valid values are `windows` and `linux`"
  default     = "linux"
}

variable "sku" {
  description = "Azure VM size (type) to be created. Consult the *VM-Series Deployment Guide* as only a few selected sizes are supported."
  default     = "Standard_D16ds_v5"
  type        = string
}

variable "admin_username" {
  description = "Initial administrative username to use for VM-Series."
  type        = string
}

variable "admin_password" {
  description = "Initial administrative password to use for VM-Series."
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "If true, disables password-based authentication on VM-Series instances."
  default     = null
  type        = bool
}

variable "encryption_at_host_enabled" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set#encryption_at_host_enabled)."
  default     = null
  type        = bool
}

variable "overprovision" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = bool
}

variable "platform_fault_domain_count" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = number
}

variable "proximity_placement_group_id" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "tags" {
  description = "Map of tags to use for all the created resources."
  default     = {}
  type        = map(string)
}

variable "zone_balance" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = bool
}

variable "zones" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = []
  type        = list(string)
}

variable "capacity_reservation_group_id" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "instances" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = null
  type        = number
}

variable "computer_name_prefix" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "provision_vm_agent" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = null
  type        = bool
}

variable "public_key" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = null
  type        = string
}

variable "network_interface" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "os_disk" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = {}
  type        = any
}

variable "data_disk" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "identity" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = {}
  type        = any
}

variable "plan" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "public_ip_address" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = {}
  type        = any
}

variable "rolling_upgrade_policy" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "secret" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "spot_restore" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = {}
  type        = any
}

variable "boot_diagnostics" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = {}
  type        = any
}

variable "upgrade_mode" {
  description = "The availability zones to use, for example `[\"1\", \"2\", \"3\"]`. If an empty list, no Availability Zones are used: `[]`."
  default     = "Manual"
  type        = string
}

variable "source_image_reference" {
  description = "See the [provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)."
  default     = {}
  type        = any
}

variable "bootstrap_options" {
  description = <<-EOF
  Bootstrap options to pass to VM-Series instance.

  Proper syntax is a string of semicolon separated properties.
  Example:
    bootstrap_options = "type=dhcp-client;panorama-server=1.2.3.4"

  A list of available properties: storage-account, access-key, file-share, share-directory, type, ip-address, default-gateway, netmask, ipv6-address, ipv6-default-gateway, hostname, panorama-server, panorama-server-2, tplname, dgname, dns-primary, dns-secondary, vm-auth-key, op-command-modes, op-cmd-dpdk-pkt-io, plugin-op-commands, dhcp-send-hostname, dhcp-send-client-id, dhcp-accept-server-hostname, dhcp-accept-server-domain, auth-key, vm-series-auto-registration-pin-value, vm-series-auto-registration-pin-id.

  For more details on bootstrapping see documentation: https://docs.paloaltonetworks.com/vm-series/10-2/vm-series-deployment/bootstrap-the-vm-series-firewall/create-the-init-cfgtxt-file/init-cfgtxt-file-components
  EOF
  default     = null
  type        = string
}

## auto scaling variables

variable "autoscale_metrics" {
  description = <<-EOF
  Map of objects, where each key is the metric name to be used for autoscaling.
  Each value of the map has the attributes `scaleout_threshold` and `scalein_threshold`, which cause the instance count to grow by 1 when metrics are greater or equal, or decrease by 1 when lower or equal, respectively.
  The thresholds are applied to results of metrics' aggregation over a time window.
  Example:
  ```
  {
    "DataPlaneCPUUtilizationPct" = {
      scaleout_threshold = 80
      scalein_threshold  = 20
    }
    "panSessionUtilization" = {
      scaleout_threshold = 80
      scalein_threshold  = 20
    }
  }
  ```

  Other possible metrics include panSessionActive, panSessionThroughputKbps, panSessionThroughputPps, DataPlanePacketBufferUtilization.
  EOF
  default     = {}
  type        = map(any)
}

variable "application_insights_id" {
  description = <<-EOF
  An ID of Application Insights instance that should be used to provide metrics for autoscaling.

  **Note**, to avoid false positives this should be an instance dedicated to this VMSS.
  ```
  EOF
  default     = null
  type        = string
}

variable "autoscale_count_default" {
  description = "The minimum number of instances that should be present in the scale set when the autoscaling engine cannot read the metrics or is otherwise unable to compare the metrics to the thresholds."
  default     = 2
  type        = number
  nullable    = false
}

variable "autoscale_count_minimum" {
  description = "The minimum number of instances that should be present in the scale set."
  default     = 2
  type        = number
  nullable    = false
}

variable "autoscale_count_maximum" {
  description = "The maximum number of instances that should be present in the scale set."
  default     = 5
  type        = number
  nullable    = false
}

variable "scaleout_statistic" {
  description = "Aggregation to use within each minute (the time grain) for metrics coming from different virtual machines. Possible values are Average, Min and Max."
  default     = "Max"
  type        = string
  nullable    = false
}

variable "scaleout_time_aggregation" {
  description = "Specifies how the metric should be combined over the time `scaleout_window_minutes`. Possible values are Average, Count, Maximum, Minimum, Last and Total."
  default     = "Maximum"
  type        = string
  nullable    = false
}

variable "scalein_statistic" {
  description = "Aggregation to use within each minute (the time grain) for metrics coming from different virtual machines. Possible values are Average, Min and Max."
  default     = "Max"
  type        = string
  nullable    = false
}

variable "scalein_time_aggregation" {
  description = "Specifies how the metric should be combined over the time `scalein_window_minutes`. Possible values are Average, Count, Maximum, Minimum, Last and Total."
  default     = "Maximum"
  type        = string
  nullable    = false
}

variable "autoscale_notification_emails" {
  description = "List of email addresses to notify about autoscaling events."
  default     = []
  type        = list(string)
  nullable    = false
}

variable "autoscale_webhooks_uris" {
  description = "Map where each key is an arbitrary identifier and each value is a webhook URI. The URIs receive autoscaling events."
  default     = {}
  type        = map(string)
}

variable "scaleout_cooldown_minutes" {
  description = "Azure only considers adding a VM after this number of minutes has passed since the last VM scaling action. It should be much higher than `scaleout_window_minutes`, to account both for the VM-Series spin-up time and for the subsequent metrics stabilization time. Must be between 1 and 10080 minutes."
  default     = 25
  type        = number
  nullable    = false
}

variable "scalein_cooldown_minutes" {
  description = "Azure only considers deleting a VM after this number of minutes has passed since the last VM scaling action. Should be higher or equal to `scalein_window_minutes`. Must be between 1 and 10080 minutes."
  default     = 2880
  type        = number
  nullable    = false
}

variable "scaleout_window_minutes" {
  description = <<-EOF
  This is amount of time in minutes that autoscale engine will look back for metrics. For example, 10 minutes means that every time autoscale runs,
  it will query metrics for the past 10 minutes. This allows metrics to stabilize and avoids reacting to transient spikes.
  Must be between 5 and 720 minutes.
  EOF
  default     = 10
  type        = number
  nullable    = false
}

variable "scalein_window_minutes" {
  description = <<-EOF
  This is amount of time in minutes that autoscale engine will look back for metrics. For example, 10 minutes means that every time autoscale runs,
  it will query metrics for the past 10 minutes. This allows metrics to stabilize and avoids reacting to transient spikes.
  Must be between 5 and 720 minutes.
  EOF
  default     = 15
  type        = number
  nullable    = false
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

