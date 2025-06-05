# Example: Key Vault with Access Policies

This example demonstrates how to deploy an Azure Key Vault with custom access policies using the abstract Key Vault module.

## What it does
- Creates a new resource group (if `create_resource_group = true`).
- Deploys a Key Vault named `policyvault` in the `australiaeast` region.
- Sets access policies for a specified object ID (user, group, or service principal).
- Tags the resources with `environment = "dev"` and other standard tags.

## Usage
```hcl
module "keyvault_policy" {
  source                = "../.."
  resource_name         = "policyvault"
  location              = "australiaeast"
  create_resource_group = true
  resource_group_name   = "example-rg"
  advanced_options = {
    access_policies = [
      {
        object_id               = "00000000-0000-0000-0000-000000000000" # Replace with a real object_id
        key_permissions         = ["Get", "List", "Create"]
        secret_permissions      = ["Get", "Set", "List"]
        certificate_permissions = ["Get", "List"]
        storage_permissions     = ["Get"]
      }
    ]
    sku_name = "standard"
  }
  tags = {
    environment = "dev"
  }
}
```

## Outputs
| Name                        | Description                                 |
|-----------------------------|---------------------------------------------|
| keyvault_policy_full_output | All outputs from the keyvault_policy module (sensitive) |
| keyvault_policy_name        | The Key Vault resource name                 |

## References
- [Main module README](../../README.md)
- [Azure Key Vault documentation](https://learn.microsoft.com/en-us/azure/key-vault/) 