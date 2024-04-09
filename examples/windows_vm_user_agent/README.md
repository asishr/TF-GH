# Palo Alto Networks Panorama Module for Azure

A terraform module for deploying a working Panorama instance in Azure.

## Usage

```hcl
module "panorama" {
    source = "../../modules/networking/vm"
    vm_name             = "VM-CC-INFRA-PRD-PANO-01"
    location            = "canadacentral"
    resource_group_name = module.resource_group_pano.name
    offer               = "panorama" 
    disk_type           = "Standard_LRS"
    sku                 = "byol"
    publisher           = "paloaltonetworks"
    vm_size             = "Standard_D5_v2"
    image_version       = "10.1.5"
    nic_name            = "VM-CC-INFRA-PRD-NIC-01"
    config_name         = "VM-CC-INFRA-PRD-CONFIG-01"
    network_security_group_id = module.network_mgmt_pano_security_rule.id
    subnet_id           = module.vnet.subnet_ids["SNET-CC-INFRA-PRD-EXTHUB-TRUST-01"]
    private_ip_address  = ["10.8.1.70", "10.8.1.71"]
    username            = "panouser"
    password            = random_password.this.result
    tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.29, < 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.7 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.7 |

## Modules

No modules.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vm_disk_attach](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_avzone"></a> [avzone](#input\_avzone) | The availability zone to use, for example "1", "2", "3". Ignored if `enable_zones` is false. Use `avzone = null` to disable the use of Availability Zones. | `any` | `null` | no |
| <a name="input_avzones"></a> [avzones](#input\_avzones) | After provider version 3.x you need to specify in which availability zone(s) you want to place IP.<br>ie: for zone-redundant with 3 availability zone in current region value will be:<pre>["1","2","3"]</pre> | `list(string)` | `[]` | no |
| <a name="input_config_name"></a> [config\_name](#input\_config\_name) | The name of VM IP Configuration | `string` | n/a | yes |   
| <a name="input_custom_image_id"></a> [custom\_image\_id](#input\_custom\_image\_id) | Absolute ID of your own Custom Image to be used for creating VM. If set, the `username`, `password`, `version`, `publisher`, `offer`, `sku` inputs are all ignored (these are used only for published images, not custom ones). The Custom Image is expected to contain PAN-OS software. | `string` | `null` | no |    
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Managed Data Disks for azure viratual machine | <pre>list(object({<br>    name                 = string<br>    storage_account_type = string<br>    disk_size_gb         = number<br>  }))</pre> | `[]` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Specifies the type of managed disk to create. Possible values are either Standard\_LRS, StandardSSD\_LRS, Premium\_LRS or UltraSSD\_LRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Should IP Forwarding be enabled? Defaults to false | `bool` | `false` | no |
| <a name="input_enable_plan"></a> [enable\_plan](#input\_enable\_plan) | Enable usage of the Offer/Plan on Azure Marketplace. Even plan sku "byol", which means "bring your own license", still requires accepting on the Marketplace (as of 2021). Can be set to `false` when using a custom image. | `bool` | `true` | no |
| <a name="input_enable_zones"></a> [enable\_zones](#input\_enable\_zones) | If false, the input `avzone` is ignored and all created public IPs default not to use Availability Zones (the `No-Zone` setting). It is intended for the regions that do not yet support Availability Zones. | `bool` | `true` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | VM Software version. For Panorama, list published images with `az vm image list -o table --all --publisher paloaltonetworks --offer panorama` | `string` | `null` | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | The number of Virtual Machines required. | `number` | `1` | no |
| <a name="input_internal_dns_name_label"></a> [internal\_dns\_name\_label](#input\_internal\_dns\_name\_label) | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Region to deploy Panorama into. | `string` | n/a | yes |
| <a name="input_logging_disks"></a> [logging\_disks](#input\_logging\_disks) | A map of objects describing the additional disk configuration. The keys of the map are the names and values are { size, zone, lun }. <br> The size value is provided in GB. The recommended size for additional (optional) disks is at least 2TB (2048 GB). Example:<pre>{<br>  logs-1 = {<br>    size: "2048"<br>    zone: "1"<br>    lun: "1"<br>  }<br>  logs-2 = {<br>    size: "2048"<br>    zone: "2"<br>    lun: "2"<br>    disk_type: "StandardSSD_LRS"<br>  }<br>}</pre> | `map(any)` | `{}` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | (Optional) Specifies the identifier for the VM network security group. | `any` | `null` | no |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | VM Netwok Interface name | `string` | n/a | yes |
| <a name="input_offer"></a> [offer](#input\_offer) | Image Offer. | `string` | `null` | no |
| <a name="input_os_disk_name"></a> [os\_disk\_name](#input\_os\_disk\_name) | The name of OS disk. The name is auto-generated when not provided. | `string` | `null` | no |
| <a name="input_password"></a> [password](#input\_password) | Initial administrative password to use for VM. If not defined the `ssh_key` variable must be specified. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-password-requirements-when-creating-a-vm). | `string` | `null` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | The Static IP Address which should be used. This is valid only when `private_ip_address_allocation` is set to `Static` | `any` | `null` | no |
| <a name="input_private_ip_address_allocation_type"></a> [private\_ip\_address\_allocation\_type](#input\_private\_ip\_address\_allocation\_type) | The allocation method used for the Private IP Address. Possible values are Dynamic and Static. | `string` | `"Static"` | no |
| <a name="input_publisher"></a> [publisher](#input\_publisher) | Image Publisher. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the existing resource group where to place all the resources created by this module. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | VM SKU. | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | A list of initial administrative SSH public keys that allow key-pair authentication.<br><br>This is a list of strings, so each item should be the actual public key value. If you would like to load them from files instead, following method is available:<pre>[<br>  file("/path/to/public/keys/key_1.pub"),<br>  file("/path/to/public/keys/key_2.pub")<br>]</pre>If the `password` variable is also set, VM-Series will accept both authentication methods. | `list(string)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID of the VM network interface | `string` | n/a | yes |   
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to be associated with the resources created. | `map(any)` | `{}` | no |
| <a name="input_username"></a> [username](#input\_username) | Initial administrative username to use for VM. Mind the [Azure-imposed restrictions](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/faq#what-are-the-username-requirements-when-creating-a-vm). | `string` | `"panadmin"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The VM common name. | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Virtual Machine size. | `string` | `"Standard_D5_v2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface"></a> [interface](#output\_interface) | Panorama network interface. The `azurerm_network_interface` object. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->