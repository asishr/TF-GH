provider "azurerm" {
  features {}
}
provider "azuread" {
}

data "azurerm_storage_account" "example" {
  name                = "tfstatestorageac"
  resource_group_name = "Tfstate-RG"
}

module "example_role_assignment" {
  source = "../../modules/security/role_assignment"
  scope  = data.azurerm_storage_account.example.id
  role_assignments = {
    Owner = [{
      description    = "testing assignement of owner for asishracha "
      user_name      = "asishracha@microsoft.com"
      principal_id   = "1bb208f6-fb13-4786-bd8b-e477d83da0a9"
      skip_aad_check = false
      timeouts = {
        read = "30m"
      }
    }]
    Contributor = [{
      description           = "testing assignement of Contributor for SPN"
      serviceprincipal_name = "TFP-ARM-SPN"
      principal_id          = "3f9cd5ba-2c14-4c04-a78d-b01511029049"
      skip_aad_check        = true
    }]
  }
}

