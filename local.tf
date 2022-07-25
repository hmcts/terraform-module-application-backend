locals {
  gateways        = yamldecode(data.local_file.configuration.content).gateways
  resource_prefix = var.resource_prefix != null ? "${var.resource_prefix}-" : ""
}