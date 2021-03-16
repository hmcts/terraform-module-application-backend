
resource "azurerm_public_ip" "app_gw" {
  count               = length(var.private_ip_address)
  name                = element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "aks-appgw-${var.env}-pip" : "aks-appgw-${var.env}-pip-${count.index}"
  location            = var.location
  resource_group_name = var.vnet_rg
  sku                 = "Standard"
  allocation_method   = "Static"
}