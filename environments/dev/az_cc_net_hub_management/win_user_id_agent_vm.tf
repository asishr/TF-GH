# Network security group for Win User-ID Agent VM Network Interface
module "network_user_id_agent_security_rule" {
  source                 = "../modules/networking/network_security_group"
  for_each               = var.locations
  name                   = "${var.virtual_machine_prefix}UID-NIC-NSG"
  location               = each.value.name
  resource_group_name    = module.resource_group_uid[each.key].name
  network_security_rules = each.value.win_uid_network_security_rules
  depends_on             = [module.mgmt_vnet]
}

# Create the a Win User-ID Agent VM.
module "win_user_id_agent" {
  source = "../modules/compute/vm/windows_vm"
  for_each                  = var.locations
  virtual_machine_name      = "${var.virtual_machine_prefix}UID"  
  location                  = each.value.name
  resource_group_name       = module.resource_group_uid[each.key].name
  source_image_id           = "/subscriptions/9ecfa923-c406-4a0d-a30e-dd888013baa5/resourceGroups/RG-CC-INFRA-PRD-CUSTOM-IMAGES/providers/Microsoft.Compute/galleries/IGMImageGallery/images/IGM-Win2019-CIS"
  license_type              = "Windows_Server"
  nic_name                  = "${var.virtual_machine_prefix}UID-NIC"
  config_name               = "${var.virtual_machine_prefix}UID-CONFIG"
  network_security_group_id = module.network_user_id_agent_security_rule[each.key].id
  virtual_machine_size      = "Standard_F4s_v2"
  tags                      = var.tags
  subnet_id                 = module.mgmt_vnet[each.key].subnet_ids["SNET-${each.value.alias}-NET-${var.environment}-HUB-PAFW-MGMT-01"]
  private_ip_address        = each.value.win_uid_private_ip_address
  admin_username            = var.username
  admin_password            = var.pswd
  depends_on                = [module.network_user_id_agent_security_rule, module.mgmt_vnet]
}

