# terraform-module-application-backend

Terraform module to create Azure Application Gateway backend resource.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.ag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_monitor_diagnostic_setting.diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.diagnostics_access_logs_la](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.diagnostics_access_logs_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_public_ip.app_gw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subnet.app_gw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [local_file.configuration](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_pool_ip_addresses"></a> [backend\_pool\_ip\_addresses](#input\_backend\_pool\_ip\_addresses) | list of ip addresses to add to the backend pool | `any` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common Tags | `map(string)` | n/a | yes |
| <a name="input_diagnostics_storage_account_id"></a> [diagnostics\_storage\_account\_id](#input\_diagnostics\_storage\_account\_id) | ID of a storage account to send access logs to. | `any` | `null` | no |
| <a name="input_enable_multiple_availability_zones"></a> [enable\_multiple\_availability\_zones](#input\_enable\_multiple\_availability\_zones) | n/a | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | environment, will be used in resource names and for looking up the vnet details | `any` | n/a | yes |
| <a name="input_key_vault_resource_group"></a> [key\_vault\_resource\_group](#input\_key\_vault\_resource\_group) | Name of the resource group for the keyvault | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | location to deploy resources to | `any` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | n/a | `any` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | n/a | `number` | `10` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | n/a | `number` | `2` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | IP address to allocate staticly to app gateway, must be in the subnet for the env | `any` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Optional name prefix for resources | `string` | `null` | no |
| <a name="input_send_access_logs_to_log_analytics"></a> [send\_access\_logs\_to\_log\_analytics](#input\_send\_access\_logs\_to\_log\_analytics) | Send access logs to log analytics workspace, this can be quite expensive on busy instances so disable it and send to Storage account instead | `bool` | `false` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Application Gateway SSL configuration | <pre>object({<br>    disabled_protocols   = optional(list(string))<br>    policy_type          = optional(string)<br>    policy_name          = optional(string)<br>    cipher_suites        = optional(list(string))<br>    min_protocol_version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | vault name | `any` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the Virtual Network | `string` | n/a | yes |
| <a name="input_vnet_rg"></a> [vnet\_rg](#input\_vnet\_rg) | Name of the virtual Network resource group | `string` | n/a | yes |
| <a name="input_yaml_path"></a> [yaml\_path](#input\_yaml\_path) | path to yaml config file | `any` | n/a | yes |

## Outputs

No output.

