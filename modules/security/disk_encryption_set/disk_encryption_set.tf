# Encryption Key 
resource "azurerm_key_vault_key" "des_key" {
    name         = var.des_key_name
    key_size     = 4096
    key_type     = "RSA"
    key_vault_id = var.keyvault_id
    key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
    ]
    tags = var.tags
}

resource "azurerm_disk_encryption_set" "encryption_set" {
  name                      = var.ade_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  key_vault_key_id          = azurerm_key_vault_key.des_key.id
  auto_key_rotation_enabled = try(var.auto_key_rotation_enabled, null)
  encryption_type           = try(var.encryption_type, null)

  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}