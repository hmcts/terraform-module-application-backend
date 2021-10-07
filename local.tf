locals {
  gateways                  = yamldecode(data.local_file.configuration.content).gateways
  enable_availability_zones = var.availability_zones != null ? 1 : 0
}