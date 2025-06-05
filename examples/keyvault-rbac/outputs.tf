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

output "full_output_object_public" {
  description = "All outputs from the keyvault_rbac module."
  value       = module.keyvault_rbac.full_output_object_public
}

output "keyvault_rbac_name" {
  description = "The Key Vault resource name."
  value       = module.keyvault_rbac.name
} 

output "keyvault_rbac_resource_group_name" {
  description = "The name of the resource group."
  value       = module.keyvault_rbac.resource_group_name
}

output "keyvault_rbac_vault_uri" {
  description = "The URI of the Key Vault."
  value       = module.keyvault_rbac.vault_uri
} 