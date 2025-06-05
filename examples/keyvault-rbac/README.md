# Example: Key Vault with RBAC

This example demonstrates how to deploy an Azure Key Vault with RBAC (Role-Based Access Control) enabled using the abstract Key Vault module.

## What it does
- Creates a new resource group (if `create_resource_group = true`).
- Deploys a Key Vault named `rbacvault` in the `australiaeast` region.
- Enables RBAC authorization for the Key Vault.
- Tags the resources with `environment = "dev"` and other standard tags.

## Usage
```hcl
module "keyvault_rbac" {
  source                = "../.."
  resource_name         = "rbacvault"
  location              = "australiaeast"
  create_resource_group = true
  resource_group_name   = "example-rg"
  advanced_options = {
    enable_rbac_authorization = true
    sku_name                  = "standard"
  }
  tags = {
    environment = "dev"
  }
}
```

## Outputs
| Name                      | Description                                 |
|---------------------------|---------------------------------------------|
| keyvault_rbac_full_output | All outputs from the keyvault_rbac module (sensitive) |
| keyvault_rbac_name        | The Key Vault resource name                 |

## References
- [Main module README](../../README.md)
- [Azure Key Vault documentation](https://learn.microsoft.com/en-us/azure/key-vault/) 