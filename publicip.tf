
resource "azurerm_public_ip" "app_gw" {
  count               = length(var.private_ip_address)
  name                = (var.create_new_agw == true) ? local.new_pip_name : local.pip_name
  location            = var.location
  resource_group_name = var.vnet_rg
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.common_tags
}