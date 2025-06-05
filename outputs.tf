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

output "name" {
  description = "CAF-compliant resource name."
  value       = local.name
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = local.selected_resource_group_name
}

output "resource_location" {
  description = "The location used for the resource."
  value       = local.resource_location
}

output "resource_tags" {
  description = "The tags used for the resource."
  value       = local.resource_tags
}

output "merged_options" {
  description = "The merged advanced options and sensitive values used for the resource."
  value       = local.merged_options
  sensitive   = true
}

output "vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}

output "full_output_object_sensitive" {
  description = "Sensitive values from the Key Vault output."
  value = {
    merged_options = local.merged_options
  }
  sensitive = true
}

output "full_output_object_public" {
  description = "Non-sensitive values from the Key Vault output."
  value = {
    name              = local.name
    resource_location = local.resource_location
    resource_tags     = local.resource_tags
    vault_uri         = azurerm_key_vault.this.vault_uri
  }
}