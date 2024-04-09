provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "nsg-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}

module "firewall_policy" {
  source              = "../../modules/networking/firewall_policy"
  name                = "testfirewall-policy"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  rule_collection_group = [{
    name               = "example-fwpolicy-rcg"
    priority           = 500

    network_rule_collection = [{
      name     = "network_rule_collection1"
      priority = 400
      action   = "Deny"
      rule = [{
        name                  = "network_rule_collection1_rule1"
        protocols             = ["TCP", "UDP"]
        source_addresses      = ["10.0.0.1"]
        destination_addresses = ["192.168.1.1", "192.168.1.2"]
        destination_ports     = ["80", "1000-2000"]
      }]
    }]

    nat_rule_collection = [{
      name     = "nat_rule_collection1"
      priority = 300
      action   = "Dnat"
      rule = [{
        name                = "nat_rule_collection1_rule1"
        protocols           = ["TCP", "UDP"]
        source_addresses    = ["10.0.0.1", "10.0.0.2"]
        destination_address = "192.168.1.1"
        destination_ports   = ["80"]
        translated_address  = "192.168.0.1"
        translated_port     = "8080"
      }]
    }]

    application_rule_collection = [{
      name     = "app_rule_collection1"
      priority = 500
      action   = "Deny"
      rule =[{
        name = "app_rule_collection1_rule1"
        protocols = {
          type = "Http"
          port = 80
        }
        protocols = {
          type = "Https"
          port = 443
        }
        source_addresses  = ["10.0.0.1"]
        destination_fqdns = ["*.microsoft.com"]
      }]
    }]
  }]
}
