# Generate a random storage name
resource "random_string" "tf-name" {
  length  = 8
  upper   = false
  lower   = false
  special = false
}

# Create a Resource Group for the Terraform State File
module "resource_group" {
  source   = "../modules/common/resource_group"
  name     = "rg-terraform-tfstate-cc"
  location = var.location
  tags     = { "CostCenter" = "1234" }
}

# Create a Storage Account for the Terraform State File
module "storage" {
  source  = "../modules/common/storage_account"
  name                  = "satftfstatebackend"
  resource_group_name   = module.resource_group.name
  location              = var.location
  account_tier          = "Standard"
  account_replication_type = "LRS"
  containers = [{
    name = "tfstate"
  }]
  # lifecycle = {
  #   prevent_destroy = true
  # }  

  tags = { "CostCenter" = "1234" }
}
