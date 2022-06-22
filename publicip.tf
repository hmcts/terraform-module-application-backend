
resource "azurerm_public_ip" "app_gw" {
  count               = length(var.private_ip_address)
  name                = element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "${local.resource_prefix}aks-appgw-${var.env}-pip" : "${local.resource_prefix}aks-appgw-${var.env}-pip-${count.index}"
  location            = var.location
  zones               = var.public_ip_enable_multiple_availability_zones == true ? ["1", "2", "3"] : []
  resource_group_name = var.vnet_rg
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.common_tags
}