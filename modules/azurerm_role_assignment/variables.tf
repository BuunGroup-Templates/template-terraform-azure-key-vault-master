variable "scope" {
  description = "The scope at which to assign the role (e.g., Key Vault resource ID, subscription, resource group, etc.)."
  type        = string
  validation {
    condition     = length(var.scope) > 0
    error_message = "scope must not be empty."
  }
}

variable "role_definition_name" {
  description = "The name of a built-in Azure role to assign (e.g., 'Key Vault Secrets User'). Either this or role_definition_id must be set."
  type        = string
  default     = null
}

variable "role_definition_id" {
  description = "The ID of a custom Azure role to assign. Either this or role_definition_name must be set. Should be a valid GUID."
  type        = string
  default     = null
  validation {
    condition     = var.role_definition_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.role_definition_id))
    error_message = "role_definition_id must be a valid GUID if provided."
  }
}

variable "principal_id" {
  description = "The object ID of the principal (user, group, or service principal) to assign the role to."
  type        = string
  validation {
    condition     = length(var.principal_id) > 0
    error_message = "principal_id must not be empty."
  }
}

variable "name" {
  description = "A unique UUID/GUID for this Role Assignment. One will be generated if not specified."
  type        = string
  default     = null
  validation {
    condition     = var.name == null || can(regex("^[0-9a-fA-F-]{36}$", var.name))
    error_message = "name must be a valid GUID if provided."
  }
}

variable "principal_type" {
  description = "The type of the principal_id. Possible values are User, Group, and ServicePrincipal."
  type        = string
  default     = null
  validation {
    condition     = var.principal_type == null || contains(["User", "Group", "ServicePrincipal"], var.principal_type)
    error_message = "principal_type must be one of 'User', 'Group', or 'ServicePrincipal' if provided."
  }
}

variable "condition" {
  description = "The condition that limits the resources that the role can be assigned to."
  type        = string
  default     = null
}

variable "condition_version" {
  description = "The version of the condition. Possible values are 1.0 or 2.0. Must be set if condition is set."
  type        = string
  default     = null
  validation {
    condition     = var.condition_version == null || contains(["1.0", "2.0"], var.condition_version)
    error_message = "condition_version must be '1.0' or '2.0' if provided."
  }
}

variable "delegated_managed_identity_resource_id" {
  description = "The delegated Azure Resource Id which contains a Managed Identity. Used in cross tenant scenarios."
  type        = string
  default     = null
}

variable "description" {
  description = "The description for this Role Assignment."
  type        = string
  default     = null
}

variable "skip_service_principal_aad_check" {
  description = "If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check. Defaults to false."
  type        = bool
  default     = false
}

# Cross-variable validation (only one of role_definition_name or role_definition_id must be set)
locals {
  role_definition_set_count = length(compact([var.role_definition_name, var.role_definition_id]))
}

resource "null_resource" "validate_role_definition" {
  count = local.role_definition_set_count == 1 ? 0 : 1
  provisioner "local-exec" {
    command = "echo 'Error: You must set exactly one of role_definition_name or role_definition_id.' && exit 1"
  }
}

# Cross-variable validation: condition_version only if condition is set
resource "null_resource" "validate_condition_version" {
  count = (var.condition_version != null && var.condition == null) ? 1 : 0
  provisioner "local-exec" {
    command = "echo 'Error: condition_version is set but condition is not. Both must be set together.' && exit 1"
  }
} 