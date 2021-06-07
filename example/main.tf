provider "azurerm" {
  features {}
}

module "app-gw" {
  source = "../"

  yaml_path                  = "${path.cwd}/config.yaml"
  env                        = "local"
  location                   = "uksouth"
  private_ip_address         = ["10.10.7.112"]
  backend_pool_ip_addresses  = ["10.100.1.1"]
  vault_name                 = "acmedcdcftappssbox"
  vnet_rg                    = "aks-infra-sbox-rg"
  vnet_name                  = "core-sbox-vnet"
  common_tags                = {}
  log_analytics_workspace_id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/oms-automation/providers/Microsoft.OperationalInsights/workspaces/hmcts-sandbox"
  key_vault_resource_group   = "cft-platform-sbox-rg"
}
