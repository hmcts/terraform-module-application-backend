# terraform-module-application-backend

Terraform module to create Azure Application Gateway backend resource.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend_pool_ip_addresses | List of ip addresses to add to the backend pool | `any` | n/a | yes |
| common\_tags | Common Tags | `map(string)` | n/a | yes |
| env | environment, will be used in resource names and for looking up the vnet details | `any` | n/a | yes |
| key_vault_resource_group | Name of the resource group for the keyvault | `string` | n/a | yes |
| location | location to deploy resources to | `any` | n/a | yes |
| log\_analytics\_workspace\_id | Enter log analytics workspace id | `string` | n/a | yes |
| private\_ip\_address | IP address to allocate staticly to app gateway, must be in the subnet for the env | `any` | n/a | yes |
| resource_prefix | Resource name prefix | `string` | n/a | no |
| vault\_name | Name of the Key Vault | `string` | n/a | yes |
| vnet\_name | Name of the Virtual Network | `string` | n/a | yes |
| vnet\_rg | Name of the virtual Network resource group | `string` | n/a | yes |

## Outputs

No output.

