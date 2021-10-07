locals {
  gateways                        = yamldecode(data.local_file.configuration.content).gateways
  regions_with_availability_zones = ["UK South", "West Europe", "eastus", "North Europe"]
  zones                           = contains(local.regions_with_availability_zones, var.location) ? list("1", "2", "3") : null
}