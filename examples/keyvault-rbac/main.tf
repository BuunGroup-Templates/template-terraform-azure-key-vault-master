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

  role_assignments = {
    keyvault_secret_user = {
      scope                = module.keyvault_rbac.vault_uri # or azurerm_key_vault.this.id if available
      role_definition_name = "Key Vault Secrets User"
    }
    # Add more role assignments as needed
  }
}

module "ephemeral_secret_single" {
  source = "git::https://github.com/BuunGroup-Templates/template-terraform-azure-ephemeral-secret-slave.git//?ref=main"

  key_vault = {
    name                = module.keyvault_rbac.name
    resource_group_name = module.keyvault_rbac.resource_group_name
  }

  secrets = {
    my_secret = {
      name         = "my-secret"
    }
  }
  depends_on = [module.keyvault_rbac]
}
