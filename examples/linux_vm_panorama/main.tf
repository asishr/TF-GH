provider "azurerm" {
  features {}
}

# Generate a random password.
resource "random_password" "this" {
    length           = 16
    min_lower        = 16 - 4
    min_numeric      = 1
    min_special      = 1
    min_upper        = 1
    special          = true
    override_special = "_%@"
}

# Create the Resource Group for Panorama VMs.
module "resource_group_pano" {
    source                = "../../modules/common/resource_group"
    name                  = "RG-CC-INFRA-PRD-PANO-01"
    location              = "canadacentral"
    tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}

# Create the VNET for Panorama VMs.
module "vnet" {
    source              = "../../modules/networking/virtual_network"
    name                = "VN-CC-INFRA-PRD-EXTHUB-01"
    resource_group_name = module.resource_group_pano.name
    location            = "canadacentral"
    address_space = ["10.8.0.0/23", "10.94.239.24/29"]
    subnets = [{
        name                   = "SNET-CC-INFRA-PRD-EXTHUB-MGMT-01"
        address_prefixes       = ["10.8.0.128/26"]
        network_security_group = "sg_mgmt"
        route_table            = "SN-CC-UDR-DEFAULT-INTERNET"
        },
        {
          name                   = "SNET-CC-INFRA-PRD-EXTHUB-UNTRUST-01"
          address_prefixes       = ["10.8.1.128/26"]
          network_security_group = "sg_untrust"
          route_table            = "SN-CC-RT-UNTRUST"
        },
        {
          name                   = "SNET-CC-INFRA-PRD-EXTHUB-TRUST-01"
          address_prefixes       = ["10.8.1.64/26"]
          network_security_group = "sg_trust"
          route_table            = "N-CC-RT-TRUST"
        },
        {
          name             = "AzureFirewallSubnet"
          address_prefixes = ["10.8.1.0/26"]
        },   
        {
          name             = "AzureBastionSubnet"
          address_prefixes = ["10.8.0.32/27"]

        }
    ]
    tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}

# Network security group for Panorama VM Management Network Interface
module "network_mgmt_pano_security_rule" {
    source                 = "../../modules/networking/network_security_group"
    name                   = "AZCCPRDPAFW01-PANO-NSG"
    location               = "canadacentral"
    resource_group_name    = module.resource_group_dmz.name
    pano_network_security_rules = [{
        name                       = "ALLOW_PORT_161"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = 1030
        protocol                   = "*"
        source_port_range          = "*"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
        destination_port_range     = "161"

      },
      {
        name                       = "MGMT"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = 1010
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
        destination_port_range     = "443"

      },
      {
        name                       = "ssh"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = 110
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
        destination_port_range     = "22"

      }]
    depends_on             = [module.vnet]
}

# Create the a Panorama VM.

module "panorama" {
  source = "../../../modules/compute/vm/linux_vm"
  virtual_machine_name      = "VM-CC-INFRA-PRD-PANO-01"
  location                  = "canadacentral"
  resource_group_name       = module.resource_group_pano.name
  data_disks                = {
      name                  = "disk2"
      disk_size_gb          = 200
      storage_account_type  = "Standard_LRS"
  }
  image_reference_publisher = "paloaltonetworks"
  image_reference_offer     = "panorama"
  image_reference_sku       = "byol"
  image_reference_version   = "10.1.5"
  nic_name                  = "VM-CC-NET-PRD-NIC-01"
  config_name               = "VM-CC-NET-PRD-CONFIG-01"
  network_security_group_id = module.network_mgmt_pano_security_rule.id
  subnet_id                 = module.vnet.subnet_ids["SNET-CC-INFRA-PRD-EXTHUB-TRUST-01"]
  private_ip_address        = ["10.8.1.70", "10.8.1.71"]
  admin_username            = "panouser"
  admin_password            = random_password.this.result
  generate_admin_ssh_key    = true
  tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}