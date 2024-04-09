
variable "instances_count" {
    description = "The number of Virtual Machines required."
    type        = number
    default     = 1
}

variable "nic_name" {
    description = "VM Netwok Interface name"
    type        = string
}

variable "location" {
  description   = "Region to deploy Panorama into."
  type          = string
}

variable "resource_group_name" {
    description = "The name of the existing resource group where to place all the resources created by this module."
    type        = string
}

variable "dns_servers" {
    description = "List of dns servers to use for network interface"
    type        = any
     default    = []
}

variable "enable_ip_forwarding" {
    description = "Should IP Forwarding be enabled? Defaults to false"
    type        = bool
    default     = false
}

variable "enable_accelerated_networking" {
    description = "Should Accelerated Networking be enabled? Defaults to false."
    type        = bool
    default     = true
}

variable "internal_dns_name_label" {
    description = "The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
    type        = string
    default     = null
}

variable "tags" {
    description = "A map of tags to be associated with the resources created."
    default     = {}
    type        = map(any)
}

variable "config_name" {
    description = "The name of VM IP Configuration"
    type        = string
}

variable "subnet_id" {
    description = "Subnet ID of the VM network interface"
    type        = string
}

variable "private_ip_address_allocation_type" {
    description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
    type        = string
    default     = "Static"
}

variable "private_ip_address" {
    description = "The Static IP Address which should be used. This is valid only when `private_ip_address_allocation` is set to `Static` "
    type        = any
    default     = null
}

variable "public_ip" {
    description = "Reference to a Public IP Address to associate with the NIC"
    type        = string
    default     = null
}

variable "enable_public_ip_address" {
    description = "Reference to a Public IP Address to associate with the NIC"
    type        = bool
    default     = false
}

variable "network_security_group_id" {
    description = " (Optional) Specifies the identifier for the VM network security group."
    type        = any
    default     = null
}

variable "virtual_machine_name" {
    description = "The name of the virtual machine."
    type        = string
    default     = ""
}

variable "license_type" {
    description = "Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server"
    type        = string
    default     = null
}

variable "patch_mode" {
    description = "The patching mode of the virtual machines being deployed, default is Manual"
    type        = string
    default     = "Manual"
}

variable "enable_automatic_updates" {
    description = "Should automatic updates be enabled? Defaults to false"
    type        = string
    default     = false
}

variable "admin_username" {
    description = "Initial administrative username to use for VM. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm)."
    default     = "panadmin"
    type        = string
}

variable "admin_password" {
    description = "The Password which should be used for the local-administrator on this Virtual Machine"
    type        = string
    default     = null
}

variable "virtual_machine_size" {
    description = "The Virtual Machine SKU for the Virtual Machine, Default is default Standard F8s v2"
    type        = string
    default     = "Standard_F16s"
}

variable "vm_availability_zone" {
    description = "The Zone in which this Virtual Machine should be created. Conflicts with availability set and shouldn't use both"
    type        = any
    default     = null
}

variable "timezone" {
    default     = "GMT Standard Time"
    description = "The timezone for your VM to be deployed with"
    type        = string
}

variable "enable_encryption_at_host" {
    description = " Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
    type        = string
    default     = false
}

variable "allow_extension_operations" {
    description = "Whether extensions are allowed to execute on the VM"
    type        = bool
    default     = true
}

variable "provision_vm_agent" {
    description = "Whether the Azure agent is installed on this VM, default is true"
    type        = bool
    default     = true
}

variable "source_image_id" {
    description = "The ID of an Image which each Virtual Machine should be based on"
    type        = string
    default     = null
}

variable "image_reference_publisher" {
    description = "(Optional) Specifies the publisher of the image used to create the virtual machines."
    type        = string
    default     = null
}
variable "image_reference_offer" {
    description = "(Optional) Specifies the offer of the image used to create the virtual machines."
    type        = string
    default     = null
}
variable "image_reference_sku" {
    description = "(Optional) Specifies the SKU of the image used to create the virtual machines."
    type        = string
    default     = null
}

variable "image_reference_version" {
    description = "(Optional) Specifies the version of the image used to create the virtual machines."
    type        = string
    default     = null
}

variable "enable_plan" {
  description = "Enable usage of the Offer/Plan on Azure Marketplace. Even plan sku \"byol\", which means \"bring your own license\", still requires accepting on the Marketplace (as of 2021). Can be set to `false` when using a custom image."
  default     = false
  type        = bool
}

variable "identity_ids" {
    description = "Specifies a list of user managed identity ids to be assigned to the VM."
    type        = list(string)
    default     = []
}

variable "identity_type" {
    description = "The Managed Service Identity Type of this Virtual Machine."
    type        = string
    default     = ""
}

variable "managed_identity_type" {
    description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
    type        = string
    default     = null
}

variable "spot_instance" {
    description = "Whether the VM is a spot instance or not"
    type        = bool
    default     = false
}

variable "spot_instance_eviction_policy" {
    default     = null
    description = "The eviction policy for a spot instance"
    type        = string
}

variable "spot_instance_max_bid_price" {
    default     = null
    description = "The max bid price for a spot instance"
    type        = string
}

variable "os_disk_storage_account_type" {
    description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
    type        = string
    default     = "Premium_LRS"
}

variable "disk_size_gb" {
    description = "The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from."
    type        = string
    default     = null
}

variable "enable_boot_diagnostics" {
    description = "Should the boot diagnostics enabled?"
    type        = bool
    default     = false
}

variable "storage_account_name" {
    description = "The name of the hub storage account to store logs"
    type        = string
    default     = null
}

variable "storage_account_uri" {
    description = "The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics."
    type        = string
    default     = null
}

variable "os_disk_name" {
    description = "The name which should be used for the Internal OS Disk"
    type        = string
    default     = null
}

variable "data_disks" {
    description = "Managed Data Disks for azure viratual machine"
    type = list(object({
        name                 = string
        storage_account_type = string
        disk_size_gb         = number
    }))
    default = []
}
