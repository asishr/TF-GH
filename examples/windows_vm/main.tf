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
module "resource_group_uid" {
    source                            = "../../modules/common/resource_group"
    name                              = "RG-CC-SEC-PRD-PALO-ALTO-WIN-USERID-AGENT"
    location                          = "canadacentral"
    tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Win User-ID Agent"
    }
}

# Create the VNET for Panorama VMs.
module "vnet" {
    source              = "../../modules/networking/virtual_network"
    name                = "VN-IGM-CAC-HUB-01"
    resource_group_name = module.resource_group_uid.name
    location            = "canadacentral"
    address_space = ["10.8.0.0/23", "10.94.239.24/29"]
    subnets = [{
        name                   = "SNET-CC-INFRA-PRD-EXTHUB-ADDS-01"
        address_prefixes       = ["10.8.0.64/27"]
        network_security_group = "nsg-igm-cc-hub-01"
        route_table            = "SN-CC-HUB-AD-UDR-EW-INET"
    }]
    tags = {
        Application                   = "Palo Alto Firewall"
        Environment                   = "Production"
        Owner                         = "Infra"
        CostCenter                    = "Networking"
        Node                          = "Panorama"
    }
}

# Network security group for Panorama VM Management Network Interface
module "network_mgmt_uid_security_rule" {
    source                 = "../../modules/networking/network_security_group"
    name                   = "AZCCPRDPAFW01-UID-NSG"
    location               = "canadacentral"
    resource_group_name    = module.resource_group_uid.name
    win_uid_network_security_rules = [{
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
  source = "../../../modules/compute/vm/windows_vm"
  virtual_machine_name      = "VM-CC-INFRA-PRD-PANO-01"
  location                  = "canadacentral"
  resource_group_name       = module.resource_group_uid.name
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
  subnet_id                 = module.vnet.subnet_ids["SN-CAC-HUB-ADDS"]
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