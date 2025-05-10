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


provider "azurerm" {
  features {}
  # client_id       = run.setup.client_id
  # client_secret   = run.setup.client_secret
  # tenant_id       = run.setup.tenant_id
  # subscription_id = run.setup.subscription_id
}

# run "setup" {
#   module {
#     source = "./setup"
#   }
# }

run "module_main_test" {
  command = apply

  module {
    source = "./examples"
  }

  variables {
    # Pass required variables to the module
    # greeting_prefix = "Test Greeting" # Example override
  }

  assert {
    # Check if the specific output exists and is not null
    condition     = can(module.example_root_module.hello_output) && module.example_root_module.hello_output != null
    error_message = "Module output 'hello_output' should exist and not be null"
  }
  
  assert {
    # Check the value of the output
    condition     = length(module.example_root_module.hello_output) > 0
    error_message = "Expected hello_output to be non-empty"
  }
}