variable "yaml_path" {
  description = "path to yaml config file"
}

variable "backend_pool_ip_addresses" {
  description = "list of ip addresses to add to the backend pool"
}

variable "env" {
  description = "environment, will be used in resource names and for looking up the vnet details"
}

variable "vault_name" {
  description = "vault name"
}

variable "location" {
  description = "location to deploy resources to"
}

variable "min_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 10
}

variable "private_ip_address" {
  description = "IP address to allocate staticly to app gateway, must be in the subnet for the env"
}

variable "vnet_rg" {
  description = "Name of the virtual Network resource group"
  type        = string
}
variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "key_vault_resource_group" {
  description = "Name of the resource group for the keyvault"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "log_analytics_workspace_id" {}

variable "enable_multiple_availability_zones" {
  default = false
}

variable "public_ip_enable_multiple_availability_zones" {
  default = false
}

variable "resource_prefix" {
  description = "Optional name prefix for resources"
  type        = string
  default     = null
}