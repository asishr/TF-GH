# # Encryption Key 
# resource "azurerm_key_vault_key" "des_key" {
#     name         = var.des_key_name
#     key_size     = 4096
#     key_type     = "RSA"
#     key_vault_id = var.keyvault_id
#     key_opts = [
#         "decrypt",
#         "encrypt",
#         "sign",
#         "unwrapKey",
#         "verify",
#         "wrapKey"
#     ]
#     tags = var.tags
# }