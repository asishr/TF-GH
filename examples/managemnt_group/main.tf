provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "management_groups" {
    source                      = "../../modules/management-group"
    deploy_mgmt_groups  = true
    tags = {
        businessUnit            = "HR"
        environment             = "Production"
        costcenter              = "123456"
    }
    management_groups   = {
        root = {
            name = "rootmgmtgroup"
            subscriptions = []
            #list your subscriptions ID in this field as ["GUID1", "GUID2"]
            children = {
                child1 = {
                    name = "identity"
                    subscriptions = []
                }
                child2 = {
                    name = "platform"
                    subscriptions = []
                }
                child3 = {
                    name = "management"
                    subscriptions = []
                }
            }
        }
    }
}
