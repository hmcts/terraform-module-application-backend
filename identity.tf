resource "azurerm_user_assigned_identity" "identity" {
  name                = "${local.resource_prefix}aks-${var.env}-agw"
  resource_group_name = var.vnet_rg
  location            = var.location

  tags = var.common_tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "identity" {
  principal_id = azurerm_user_assigned_identity.identity.principal_id
  scope        = data.azurerm_key_vault.main.id

  role_definition_name = "Key Vault Secrets User"
}

resource "azurerm_role_assignment" "certificates_access" {
  principal_id = azurerm_user_assigned_identity.identity.principal_id
  scope        = data.azurerm_key_vault.main.id

  role_definition_name = "Key Vault Certificates Officer"
}
