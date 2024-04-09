provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "sample-rg"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
  role_assignments = {
    Contributor = [{
      user_name      = "asishracha@microsoft.com"
      principal_id   = "1bb208f6-fb13-4786-bd8b-e477d83da0a9"
      skip_aad_check = false
    }]
  }
}
