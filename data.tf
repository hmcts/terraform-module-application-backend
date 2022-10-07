
data "local_file" "configuration" {
  filename = var.yaml_path
}


data "azurerm_subnet" "app_gw" {
  name                 = "aks-appgw"
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_name
}


# data "azurerm_key_vault" "main" {
#   name                = var.vault_name
#   resource_group_name = var.key_vault_resource_group
# }

data "azurerm_key_vault_secret" "certificate" {
  count        = length(local.gateways)
  name         = local.gateways[count.index].gateway_configuration.certificate_name
  key_vault_id = var.key_vault_id
}