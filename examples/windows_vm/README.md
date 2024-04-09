# Windows VM Module for Azure

A terraform module for deploying a working Windows VM instance in Azure.

## Usage

```hcl
# Create the a Win User-ID Agent VM.
module "win_user_id_agent" {
  source = "../modules/compute/vm/windows_vm"
  virtual_machine_name      = "VMCCINFRAPRD-UID01"  
  location                  = "canadacentral"
  resource_group_name       = module.resource_group_uid.name
  image_reference_publisher = "center-for-internet-security-inc"
  image_reference_offer     = "cis-windows-server-2019-v1-0-0-l2"
  image_reference_sku       = "cis-ws2019-l2"
  image_reference_version   = "1.2.10"
  nic_name                  = "AZCPRDNETUID-NIC-01"
  config_name               = "AZCPRDNETUIDUID-CONFIG01"
  network_security_group_id = module.network_mgmt_uid_security_rule.id
  subnet_id                 = module.vnet.subnet_ids["SNET-CC-INFRA-PRD-EXTHUB-ADDS-01"]
  private_ip_address        = ["10.8.0.72"]
  admin_username            = "panouser"
  admin_password            = random_password.this.result
  tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}
```

# Resources Created
This modules creates:
* 1 Azure Network Interface (NIC)
* 2 Azure Network Interface Security Group Association
* 3 Azure Windows Virtual Machine
* 4 Azure Mnaged Disk
* 5 Azurerm Virtual Machine Data Disk Attachment



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.28.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_managed_disk.data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.nsgassoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.windows_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The Password which should be used for the local-administrator on this Virtual Machine | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Initial administrative username to use for VM. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm). | `string` | `"panadmin"` | no |
| <a name="input_allow_extension_operations"></a> [allow\_extension\_operations](#input\_allow\_extension\_operations) | Whether extensions are allowed to execute on the VM | `bool` | `true` | no |
| <a name="input_config_name"></a> [config\_name](#input\_config\_name) | The name of VM IP Configuration | `string` | n/a | yes |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Managed Data Disks for azure viratual machine | <pre>list(object({<br>        name                 = string<br>        storage_account_type = string<br>        disk_size_gb         = number<br>    }))</pre> | `[]` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. | `string` | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for network interface | `any` | `[]` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_automatic_updates"></a> [enable\_automatic\_updates](#input\_enable\_automatic\_updates) | Should automatic updates be enabled? Defaults to false | `string` | `false` | no |
| <a name="input_enable_boot_diagnostics"></a> [enable\_boot\_diagnostics](#input\_enable\_boot\_diagnostics) | Should the boot diagnostics enabled? | `bool` | `false` | no |
| <a name="input_enable_encryption_at_host"></a> [enable\_encryption\_at\_host](#input\_enable\_encryption\_at\_host) | Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? | `string` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Should IP Forwarding be enabled? Defaults to false | `bool` | `false` | no |
| <a name="input_enable_plan"></a> [enable\_plan](#input\_enable\_plan) | Enable usage of the Offer/Plan on Azure Marketplace. Even plan sku "byol", which means "bring your own license", still requires accepting on the Marketplace (as of 2021). Can be set to `false` when using a custom image. | `bool` | `true` | no |
| <a name="input_enable_public_ip_address"></a> [enable\_public\_ip\_address](#input\_enable\_public\_ip\_address) | Reference to a Public IP Address to associate with the NIC | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned to the VM. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The Managed Service Identity Type of this Virtual Machine. | `string` | `""` | no |
| <a name="input_image_reference_offer"></a> [image\_reference\_offer](#input\_image\_reference\_offer) | (Optional) Specifies the offer of the image used to create the virtual machines. | `string` | `null` | no |
| <a name="input_image_reference_publisher"></a> [image\_reference\_publisher](#input\_image\_reference\_publisher) | (Optional) Specifies the publisher of the image used to create the virtual machines. | `string` | `null` | no |
| <a name="input_image_reference_sku"></a> [image\_reference\_sku](#input\_image\_reference\_sku) | (Optional) Specifies the SKU of the image used to create the virtual machines. | `string` | `null` | no |
| <a name="input_image_reference_version"></a> [image\_reference\_version](#input\_image\_reference\_version) | (Optional) Specifies the version of the image used to create the virtual machines. | `string` | `null` | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | The number of Virtual Machines required. | `number` | `1` | no |
| <a name="input_internal_dns_name_label"></a> [internal\_dns\_name\_label](#input\_internal\_dns\_name\_label) | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. | `string` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows\_Client and Windows\_Server | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Region to deploy Panorama into. | `string` | n/a | yes |
| <a name="input_managed_identity_type"></a> [managed\_identity\_type](#input\_managed\_identity\_type) | The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned` | `string` | `null` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | (Optional) Specifies the identifier for the VM network security group. | `any` | `null` | no |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | VM Netwok Interface name | `string` | n/a | yes |
| <a name="input_os_disk_name"></a> [os\_disk\_name](#input\_os\_disk\_name) | The name which should be used for the Internal OS Disk | `string` | `null` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | The patching mode of the virtual machines being deployed, default is Manual | `string` | `"Manual"` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | The Static IP Address which should be used. This is valid only when `private_ip_address_allocation` is set to `Static` | `any` | `null` | no |
| <a name="input_private_ip_address_allocation_type"></a> [private\_ip\_address\_allocation\_type](#input\_private\_ip\_address\_allocation\_type) | The allocation method used for the Private IP Address. Possible values are Dynamic and Static. | `string` | `"Static"` | no |
| <a name="input_provision_vm_agent"></a> [provision\_vm\_agent](#input\_provision\_vm\_agent) | Whether the Azure agent is installed on this VM, default is true | `bool` | `true` | no |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Reference to a Public IP Address to associate with the NIC | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the existing resource group where to place all the resources created by this module. | `string` | n/a | yes |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | The ID of an Image which each Virtual Machine should be based on | `string` | `null` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Whether the VM is a spot instance or not | `bool` | `false` | no |
| <a name="input_spot_instance_eviction_policy"></a> [spot\_instance\_eviction\_policy](#input\_spot\_instance\_eviction\_policy) | The eviction policy for a spot instance | `string` | `null` | no |
| <a name="input_spot_instance_max_bid_price"></a> [spot\_instance\_max\_bid\_price](#input\_spot\_instance\_max\_bid\_price) | The max bid price for a spot instance | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the hub storage account to store logs | `string` | `null` | no |
| <a name="input_storage_account_uri"></a> [storage\_account\_uri](#input\_storage\_account\_uri) | The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID of the VM network interface | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to be associated with the resources created. | `map(any)` | `{}` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | The timezone for your VM to be deployed with | `string` | `"GMT Standard Time"` | no |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | The name of the virtual machine. | `string` | `""` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The Virtual Machine SKU for the Virtual Machine, Default is default Standard F8s v2 | `string` | `"Standard_F16s"` | no |
| <a name="input_vm_availability_zone"></a> [vm\_availability\_zone](#input\_vm\_availability\_zone) | The Zone in which this Virtual Machine should be created. Conflicts with availability set and shouldn't use both | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_windows_virtual_machine_ids"></a> [windows\_virtual\_machine\_ids](#output\_windows\_virtual\_machine\_ids) | The resource id's of all windows Virtual Machine. |
| <a name="output_windows_vm_private_ips"></a> [windows\_vm\_private\_ips](#output\_windows\_vm\_private\_ips) | Public IP's map for the all windows Virtual Machines |
| <a name="output_windows_vm_public_ips"></a> [windows\_vm\_public\_ips](#output\_windows\_vm\_public\_ips) | Public IP's map for the all windows Virtual Machines |
<!-- END_TF_DOCS -->