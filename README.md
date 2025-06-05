```bash
#################################################################
#     ____  __  ____  ___   __   __________  ____  __  ______   #
#    / __ )/ / / / / / / | / /  / ____/ __ \/ __ \/ / / / __ \  #
#   / __  / / / / / / /  |/ /  / / __/ /_/ / / / / / / / /_/ /  #
#  / /_/ / /_/ / /_/ / /|  /  / /_/ / _, _/ /_/ / /_/ / ____/   #
# /_____/\____/\____/_/ |_/   \____/_/ |_|\____/\____/_/        #
#                                                               #
#                                                               #
# Buun Group Pty Ltd.                                           #
# Copyright 2025 Buun Group Pty Ltd. All rights reserved.       #
# https://buungroup.com                                         #
#                                                               #
#################################################################

```

# Abstract Azure Key Vault Module

This module provides a dynamic, best-practice pattern for deploying Azure Key Vaults using advanced Terraform features. It supports:
- Dynamic resource creation using objects/maps
- Advanced validation and null checking (try, can)
- Conditional and optional features
- Microsoft CAF naming conventions (location, environment, resource type)
- Secure handling of sensitive values
- DRY and extensible design
- Complete object map outputs
- Provider pinning and best practices
- Terraform test integration

## Usage

See the [examples](./examples/) directory for full, scenario-based usage. Example:

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

## Naming Convention
Resource names are generated as:
```
<location_prefix>-<resource_name>-<env_prefix>-kv
```
- `location_prefix`: Short code for the Azure region (e.g., `aue` for `australiaeast`)
- `resource_name`: Your provided name
- `env_prefix`: 3-letter environment code (e.g., `dev`, `prd`)
- `kv`: Hardcoded for Key Vault

## Variables

| Name                    | Description                                                                 | Type         | Default      | Required |
|-------------------------|-----------------------------------------------------------------------------|--------------|--------------|----------|
| resource_name           | The name of the Azure Key Vault (CAF format enforced).                       | string       | n/a          | yes      |
| location                | Azure region for the resource.                                              | string       | westeurope   | no       |
| resource_group_name     | The name of the resource group.                                             | string       | n/a          | yes      |
| create_resource_group   | Whether to create a new resource group (true) or use an existing one (false)| bool         | false        | no       |
| existing_resource_group_name | The name of the existing resource group to use if not creating one.      | string       | ""          | no       |
| tags                    | A map of tags to assign to the resource.                                    | map(string)  | {}           | no       |
| advanced_options        | Object of advanced or optional features for the Key Vault.                   | object       | {}           | no       |
| sensitive_values        | Map of sensitive values (e.g., secrets, keys) to be used in the resource.    | map(string)  | {}           | no       |

## Outputs

| Name                      | Description                                 | Sensitive |
|---------------------------|---------------------------------------------|-----------|
| caf_name                  | CAF-compliant resource name                 | No        |
| resource_location         | The location used for the resource          | No        |
| resource_tags             | The tags used for the resource              | No        |
| merged_options            | The merged advanced options and sensitive values | Yes   |
| full_output_object        | A complete object map of all outputs        | Yes       |

## Security & Best Practices
- All sensitive values are handled using the `sensitive` attribute and the `sensitive()` function.
- Provider and Terraform versions are pinned for reproducibility.
- Naming conventions follow Microsoft CAF using `format()` and hyphens.
- All resource arguments are passed as variables or objects for full flexibility.

## Extending the Module
- To add support for a specific Azure resource, create a submodule in `modules/<resource_name>` and import it in `main.tf`.
- Use the `advanced_options` and `sensitive_values` objects to pass any additional arguments.
- Use `for_each` and dynamic blocks for modularity and scalability.

## Versioning
- This module follows [SemVer 2.0.0](https://semver.org/).
- See releases for version history.

## Testing
- This module includes integration tests using `terraform test`.
- See the `tests/` directory for details and example configurations.
- Run tests from the module root:
  ```bash
  terraform test
  ```

## License
MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details. 