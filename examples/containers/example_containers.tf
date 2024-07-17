module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "tf-gh-sample-rg1"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}

resource "azurerm_container_registry" "acr" {
  name                = "ghContainerReg"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = "Basic"
  admin_enabled       = true
}
