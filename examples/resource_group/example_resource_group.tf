module "resource_group" {
  source   = "../../modules/common/resource_group"
  name     = "tf-gh-sample-rg1"
  location = "Canada Central"
  tags     = { "CostCenter" = "1234" }
}
