resource "azurerm_storage_account" "storeacc" {
  count = var.create_storage_account ? 1 : 0
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  min_tls_version          = var.min_tls_version
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.tags
}

data "azurerm_storage_account" "storeacc" {
  count = var.create_storage_account ? 0 : 1

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_share" "storage_share" {
  name                 = var.storage_share_name
  storage_account_name = local.storage_account.name
  quota                = var.storage_share_quota
  access_tier          = var.storage_share_access_tier
}

resource "azurerm_storage_share_directory" "share_directory" {
  for_each = toset([
    "content",
    "config",
    "software",
    "plugins",
    "license"
  ])

  name                 = each.key
  share_name           = azurerm_storage_share.storage_share.name
  storage_account_name = local.storage_account.name
}

resource "azurerm_storage_share_file" "this" {
  for_each = var.files

  name             = regex("[^/]*$", each.value)
  path             = replace(each.value, "/[/]*[^/]*$/", "")
  storage_share_id = azurerm_storage_share.storage_share.id
  source           = replace(each.key, "/CalculateMe[X]${random_id.this[each.key].id}/", "CalculateMeX${random_id.this[each.key].id}")
  depends_on = [azurerm_storage_share_directory.share_directory]
}

resource "random_id" "this" {
  for_each = var.files

  keepers = {
    # Re-randomize on every content/md5 change. It forcibly recreates all users of this random_id.
    md5 = each.key
  }
  byte_length = 8
}