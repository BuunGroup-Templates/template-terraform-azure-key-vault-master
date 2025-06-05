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

module "keyvault_policy" {
  source                  = "../.."
  resource_name           = "policyvault"
  location                = "australiaeast"
  create_resource_group   = true
  resource_group_name     = "example-rg"
  advanced_options = {
    access_policies = [
      {
        object_id           = "00000000-0000-0000-0000-000000000000"
        key_permissions     = ["Get", "List", "Create"]
        secret_permissions  = ["Get", "Set", "List"]
        certificate_permissions = ["Get", "List"]
        storage_permissions = ["Get"]
      }
    ]
    sku_name = "standard"
  }
  tags = {
    environment = "dev"
  }
} 