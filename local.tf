locals {
  gateways = yamldecode(data.local_file.configuration.content).gateways
  pip_name = element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "aks-appgw-${var.env}-pip" : "aks-appgw-${var.env}-pip-${count.index}"
  new_pip_name = element(var.private_ip_address, count.index) == var.private_ip_address[0] ? "aks-appgateway-${var.env}-pip" : "aks-appgateway-${var.env}-pip-${count.index}"
}