locals {
  use_role_definition_name = var.role_definition_name != null && var.role_definition_id == null
  use_role_definition_id   = var.role_definition_id != null && var.role_definition_name == null
}

resource "azurerm_role_assignment" "this" {
  scope                = var.scope
  principal_id         = var.principal_id

  # Only one of these should be set
  role_definition_name = local.use_role_definition_name ? var.role_definition_name : null
  role_definition_id   = local.use_role_definition_id   ? var.role_definition_id   : null

  name                              = var.name != null ? var.name : null
  principal_type                    = var.principal_type != null ? var.principal_type : null
  condition                         = var.condition != null ? var.condition : null
  condition_version                 = var.condition_version != null ? var.condition_version : null
  delegated_managed_identity_resource_id = var.delegated_managed_identity_resource_id != null ? var.delegated_managed_identity_resource_id : null
  description                       = var.description != null ? var.description : null
  skip_service_principal_aad_check  = var.skip_service_principal_aad_check
} 