
resource "azurerm_public_ip" "app_gw" {
  count               = length(var.private_ip_address)
  name                = (var.resource_prefix != null) ? (element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "${var.resource_prefix}-aks-appgw-${var.env}-pip" : "${var.resource_prefix}-aks-appgw-${var.env}-pip-${count.index}") : (element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "aks-appgw-${var.env}-pip" : "aks-appgw-${var.env}-pip-${count.index}")
  location            = var.location
  resource_group_name = var.vnet_rg
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.common_tags
}