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

variable "resource_name" {
  description = "The name of the Azure resource. Will be formatted using CAF naming."
  type        = string
  validation {
    condition     = length(var.resource_name) > 2 && can(regex("^[a-zA-Z0-9-]+$", var.resource_name))
    error_message = "resource_name must be at least 3 characters and use only alphanumeric or hyphens."
  }
}

variable "location" {
  description = "Azure region for the resource."
  type        = string
  default     = "westeurope"
  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resource."
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "advanced_options" {
  description = "Advanced or optional features for the Key Vault resource. Keys should match the resource's argument names."
  type = object({
    sku_name                        = optional(string, "standard")
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enable_rbac_authorization       = optional(bool, false)
    purge_protection_enabled        = optional(bool, true)
    soft_delete_retention_days      = optional(number, 7)
    public_network_access_enabled   = optional(bool, true)
    access_policies                 = optional(list(object({
      tenant_id                = optional(string)
      object_id                = string
      key_permissions          = optional(list(string), [])
      secret_permissions       = optional(list(string), [])
      certificate_permissions  = optional(list(string), [])
      storage_permissions      = optional(list(string), [])
    })), [])
    network_acls = optional(object({
      bypass                     = optional(string, "AzureServices")
      default_action             = optional(string, "Allow")
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }))
    contact_email = optional(string)
    depends_on    = optional(list(any), [])
    provider      = optional(string)
  })
  default = {}
}

variable "sensitive_values" {
  description = "A map of sensitive values (e.g., secrets, keys) to be used in the resource."
  type        = map(string)
  default     = {}
  sensitive   = true
}

#########################
# Conditional Variables #
#########################

variable "features" {
  description = "Feature toggles for optional behaviors in this module. Centralizes all boolean flags."
  type = object({
    create_resource_group        = optional(bool, false)
    assign_rbac_secret_user      = optional(bool, false)
    enable_rbac_authorization    = optional(bool, false)
    purge_protection_enabled     = optional(bool, true)
    # Add more feature toggles as needed
  })
  default = {}
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use if create_resource_group is false."
  type        = string
  default     = ""
}

variable "role_assignments" {
  description = "Map of role assignments to create. Keyed by a unique name. If principal_id is omitted, the current Terraform service principal will be used."
  type = map(object({
    scope                = string
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    principal_id         = optional(string)
    principal_type       = optional(string)
    condition            = optional(string)
    condition_version    = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    description          = optional(string)
    skip_service_principal_aad_check = optional(bool)
    name                 = optional(string)
  }))
  default = {}
}