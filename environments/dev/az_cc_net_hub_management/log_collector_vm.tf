# Network security group for Panorama VM Management Network Interface
module "network_mgmt_lc_security_rule" {
  source                 = "../modules/networking/network_security_group"
  for_each               = var.locations
  name                   = "${var.virtual_machine_prefix}LC-NIC-NSG"
  location               = each.value.name
  resource_group_name    = module.resource_group_log_col[each.key].name
  network_security_rules = each.value.pano_network_security_rules
  depends_on             = [module.mgmt_vnet]
}

# Create the a Panorama Log Collector Linux VM.
module "log_collector" {
  source = "../modules/compute/vm/linux_vm"
  for_each                  = var.locations
  virtual_machine_name      = "${var.virtual_machine_prefix}LC"
  location                  = each.value.name
  resource_group_name       = module.resource_group_log_col[each.key].name
  image_reference_publisher = var.panorama_publisher
  image_reference_offer     = var.panorama_offer
  image_reference_sku       = var.panorama_sku
  image_reference_version   = var.panorama_version
  virtual_machine_size      = var.panorama_lc_size
  nic_name                  = "${var.virtual_machine_prefix}LC-NIC"
  config_name               = "${var.virtual_machine_prefix}LC-CONFIG"
  network_security_group_id = module.network_mgmt_lc_security_rule[each.key].id
  tags                      = var.tags
  subnet_id                 = module.mgmt_vnet[each.key].subnet_ids["SNET-${each.value.alias}-NET-${var.environment}-HUB-PAFW-MGMT-01"]
  private_ip_address        = each.value.lc_private_ip_address
  admin_username            = var.username
  admin_password            = var.pswd
  disable_password_authentication = false
  # generate_admin_ssh_key    = var.generate_admin_ssh_key
  depends_on = [
    module.network_mgmt_lc_security_rule,
    module.mgmt_vnet
  ]
}


