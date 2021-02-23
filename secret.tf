data "azurerm_key_vault" "main" {
  name                = var.vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "azurerm_key_vault_secret" "test" {
  name         = "internal-lb-ip"
  value        = var.private_ip_address
  key_vault_id = data.azurerm_key_vault.main.id

  tags = local.tags
}