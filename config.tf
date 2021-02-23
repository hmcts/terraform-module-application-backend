data "azurerm_subnet" "app_gw" {
  name                 = "aks-appgw"
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_name

}

resource "azurerm_public_ip" "app_gw" {
  name                = "aks-appgw-${var.env}-pip"
  location            = var.location
  resource_group_name = var.vnet_rg
  sku                 = "Standard"
  allocation_method   = "Static"
}