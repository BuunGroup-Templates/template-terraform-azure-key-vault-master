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

resource "azurerm_resource_group" "this" {
  count    = try(var.features.create_resource_group, false) ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.resource_tags
}

# Key Vault resource with full dynamic and conditional features
resource "azurerm_key_vault" "this" {
  name                        = local.name
  location                    = local.resource_location
  resource_group_name         = local.selected_resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = try(local.merged_options["sku_name"], "standard")
  enabled_for_disk_encryption = try(local.merged_options["enabled_for_disk_encryption"], false)
  enabled_for_deployment      = try(local.merged_options["enabled_for_deployment"], false)
  enabled_for_template_deployment = try(local.merged_options["enabled_for_template_deployment"], false)
  enable_rbac_authorization   = try(var.features.enable_rbac_authorization, false)
  purge_protection_enabled    = try(var.features.purge_protection_enabled, true)
  soft_delete_retention_days  = try(local.merged_options["soft_delete_retention_days"], 7)
  public_network_access_enabled = try(local.merged_options["public_network_access_enabled"], true)
  tags                       = local.resource_tags

  # Access policies (optional, dynamic)
  dynamic "access_policy" {
    for_each = try(local.merged_options["access_policies"], [])
    content {
      tenant_id = try(access_policy.value.tenant_id, data.azurerm_client_config.current.tenant_id)
      object_id = access_policy.value.object_id
      key_permissions = try(access_policy.value.key_permissions, [])
      secret_permissions = try(access_policy.value.secret_permissions, [])
      certificate_permissions = try(access_policy.value.certificate_permissions, [])
      storage_permissions = try(access_policy.value.storage_permissions, [])
    }
  }

  # Network ACLs (optional, dynamic)
  dynamic "network_acls" {
    for_each = can(local.merged_options["network_acls"]) && local.merged_options["network_acls"] != null ? [local.merged_options["network_acls"]] : []
    content {
      bypass                     = try(network_acls.value.bypass, "AzureServices")
      default_action             = try(network_acls.value.default_action, "Allow")
      ip_rules                   = try(network_acls.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_acls.value.virtual_network_subnet_ids, [])
    }
  }

  # Contact emails (optional, dynamic)
  dynamic "contact" {
    for_each = try(local.merged_options["contacts"], [])
    content {
      email = contact.value.email
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  # Meta-arguments
  lifecycle {
    ignore_changes = [
      access_policy,
      tags
    ]
  }

  # Conditionally add depends_on if provided in advanced_options
  depends_on = [
    azurerm_resource_group.this
  ]
}

module "role_assignment" {
  source = "./modules/azurerm_role_assignment"
  for_each = var.role_assignments

  scope                = each.value.scope
  role_definition_name = try(each.value.role_definition_name, null)
  role_definition_id   = try(each.value.role_definition_id, null)
  principal_id         = try(each.value.principal_id, data.azurerm_client_config.current.object_id)
  principal_type       = try(each.value.principal_type, null)
  condition            = try(each.value.condition, null)
  condition_version    = try(each.value.condition_version, null)
  delegated_managed_identity_resource_id = try(each.value.delegated_managed_identity_resource_id, null)
  description          = try(each.value.description, null)
  skip_service_principal_aad_check = try(each.value.skip_service_principal_aad_check, false)
  name                 = try(each.value.name, null)
}