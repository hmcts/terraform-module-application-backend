# locals {

#   # criticality = {
#   #   sbox     = "Low"
#   #   aat      = "High"
#   #   prod     = "High"
#   #   ithc     = "Medium"
#   #   ldata    = "Medium"
#   #   perftest = "Medium"
#   #   demo     = "Medium"
#   # }

#   # env_display_names = {
#   #   sbox     = "Sandbox"
#   #   aat      = "Staging"
#   #   prod     = "Production"
#   #   ithc     = "ITHC"
#   #   ldata    = "LDATA"
#   #   perftest = "Test"
#   #   demo     = "Demo"
#   # }

#   # tags = {
#   #   "managedBy"          = "Platform Engineering"
#   #   "solutionOwner"      = "CFT"
#   #   "activityName"       = "AKS"
#   #   "dataClassification" = "Internal"
#   #   "automation"         = ""
#   #   "costCentre"         = "10245117" // until we get a better one, this is the generic cft contingency one
#   #   "environment"        = local.env_display_names[var.env]
#   #   "criticality"        = local.criticality[var.env]
#   # }
# }

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