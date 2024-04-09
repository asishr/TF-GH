# Azurerm Provider configuration
provider "azurerm" {
  features {}
}


data "azurerm_client_config" "current" {}

module "key-vault" {
  source = "../../modules/security/keyvault"
  location                                      = "canadacentral"
  resource_group_name                           = "MonitoringADFDemoRG"
  key_vault_name                                = "demoproject-kv-dc"
  key_vault_sku_pricing_tier                    = "premium"
  enable_purge_protection                       = false
  private_endpoint_resources_enabled            = []
  virtual_network_name                          = "clpshcpvnet"
  subnet_name                                   = "default"
  pe_resource_group_name                        = "cl-ic-dev-rg"
  
  private_endpoint_name                         = "privatelink.vaultcore.azure.net"

  access_policies = [
    {
      azure_ad_service_principal_names          = ["tf-sp", "very friendly name"]
      secret_permissions                        = ["Get", "List"]
    }
  ]

  tags = {
          businessUnit                          = "HR"
          environment                           = "Production"
          costcenter                            = "123456"
    }
  }
