# Azure Provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  special = false
}


module "storage" {
  source  = "../../modules/common/storage_account"
  storage_account       = var.storage_account_name
  create_resource_group = false
  resource_group_name   = "MGMT-Dev-RG"
  location              = var.location
  environment_type      = var.environment 
  security_level        = var.security_level
  business_unit         = var.business_unit
  storage_type          = var.storage_type
    # To enable advanced threat protection set argument to `true`
  enable_advanced_threat_protection = var.enable_advanced_threat_protection
  min_tls_version = var.min_tls_versionallow_blob_public_access
  containers_list = var.containers_list
  lifecycles = var.lifecycles
  tags = var.tags
  private_endpoint_resources_enabled = []
  encryption_scope_name = "microsoftmanaged"
  private_endpoint_name  = var.private_endpoint_name
  virtual_network_name                          = "vnet"
  subnet_name                                   = "default"
  pe_resource_group_name                        = "cl-ic-dev-rg"

}

  