# Network security group for Panorama VM Management Network Interface
module "network_pano_security_rule" {
  source                 = "../modules/networking/network_security_group"
  for_each               = var.locations
  name                   = "${var.virtual_machine_prefix}PM-NIC-NSG"
  location               = each.value.name
  resource_group_name    = module.resource_group_pano[each.key].name
  network_security_rules = each.value.pano_network_security_rules
  depends_on             = [module.mgmt_vnet]
}

# Create the a Panorama VM.
module "panorama" {
  source = "../modules/compute/vm/linux_vm"
  for_each                  = var.locations
  virtual_machine_name      = "${var.virtual_machine_prefix}PM"
  location                  = each.value.name
  resource_group_name       = module.resource_group_pano[each.key].name
  image_reference_publisher = var.panorama_publisher
  image_reference_offer     = var.panorama_offer
  image_reference_sku       = var.panorama_sku
  image_reference_version   = var.panorama_version
  virtual_machine_size      = var.panorama_size
  nic_name                  = "${var.virtual_machine_prefix}PM-NIC"
  config_name               = "${var.virtual_machine_prefix}PM-CONFIG"
  network_security_group_id = module.network_pano_security_rule[each.key].id
  tags                      = var.tags
  disable_password_authentication = false
  subnet_id                 = module.mgmt_vnet[each.key].subnet_ids["SNET-${each.value.alias}-NET-${var.environment}-HUB-PAFW-MGMT-01"]
  private_ip_address        = each.value.panorama_private_ip_address
  admin_username            = var.username
  admin_password            = var.pswd
  # generate_admin_ssh_key    = var.generate_admin_ssh_key
  depends_on = [
    module.network_pano_security_rule,
    module.mgmt_vnet
  ]
}

# ### BOOTSTRAPPING ###

# # Create File Share and put there files for initial boot of inbound VM-Series.
// module "bootstrap" {
//   source = "../modules/common/bootstrap"
//   for_each                = var.locations
//   resource_group_name     = module.resource_group_stg[each.key].name
//   location                = each.value.name
//   storage_share_name      = lower("ssn${each.value.alias}${var.environment}infra01")
//   storage_account_name    = lower("st${each.value.alias}${var.environment}infra01")
//   files                   = var.bootstrap_files
// }
