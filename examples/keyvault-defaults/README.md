# Example: Key Vault with Defaults

This example demonstrates how to deploy an Azure Key Vault using only the module defaults, with minimal configuration.

## What it does
- Creates a new resource group (if `create_resource_group = true`).
- Deploys a Key Vault named `defaultvault` in the `australiaeast` region.
- Uses all default settings for the Key Vault (no advanced options).
- Tags the resources with `environment = "dev"` and other standard tags.

## Usage
```hcl
module "keyvault_defaults" {
  source                = "../.."
  resource_name         = "defaultvault"
  location              = "australiaeast"
  create_resource_group = true
  resource_group_name   = "example-rg"
  tags = {
    environment = "dev"
  }
}
```

## Outputs
| Name                          | Description                                 |
|-------------------------------|---------------------------------------------|
| keyvault_defaults_full_output | All outputs from the keyvault_defaults module (sensitive) |
| keyvault_defaults_name        | The Key Vault resource name                 |

## References
- [Main module README](../../README.md)
- [Azure Key Vault documentation](https://learn.microsoft.com/en-us/azure/key-vault/) 