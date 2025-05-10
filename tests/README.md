# Terraform Module Tests

This directory contains the test configurations for this Terraform module. The tests are implemented using Terraform's built-in testing framework.

## Test Structure

```
tests/
├── README.md           # This file
├── provider.tf         # Provider configuration for tests
├── variables.tf        # Common variables used across tests
├── defaults.tftest.hcl # Test cases for default configuration
└── mock-data/         # Mock data used in tests
    └── main.tf        # Mock resource configurations
```

## Running Tests

To run all tests locally:

1. Configure your Azure credentials (environment variables or Azure CLI login)
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Run the tests:
   ```bash
   terraform test
   ```

## Test Cases

The test suite includes:

- Default configuration tests (`defaults.tftest.hcl`)
  - Validates the module works with minimal configuration
  - Checks resource creation and attributes
  - Verifies expected outputs

## Adding New Tests

1. Create a new `.tftest.hcl` file in this directory
2. Define your test cases using the standard test block syntax
3. Add mock data if needed in the `mock-data` directory
4. Update this README with details about your new test cases 