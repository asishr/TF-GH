provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "tf-gh-sample-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}
