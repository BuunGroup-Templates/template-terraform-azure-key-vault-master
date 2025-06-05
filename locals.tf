locals {
  # Get the location prefix, fallback to first 3 letters if not mapped
  location_prefix_map = jsondecode(file("${path.module}/assets/regions.json"))
  location_prefix      = lookup(local.location_prefix_map, local.resource_location, substr(local.resource_location, 0, 3))

  # Conditional data resource for existing resource group
  # Only used if create_resource_group is false
  selected_resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.existing[0].name

  # Hardcoded resource type for this module
  resource_type = "kv"

  # Environment prefix (always 3 letters, from tags/environment or default to 'dev')
  env_prefix = substr(try(var.tags["environment"], try(var.advanced_options["tags"]["environment"], "dev")), 0, 3)

  # CAF-style name: <prefix>-<resource_name>-<env_prefix>-kv
  name = format("%s-%s-%s-%s", local.resource_type, var.resource_name, local.location_prefix, local.env_prefix)

  merged_options = merge(
    var.advanced_options,
    { for k, v in var.sensitive_values : k => v if can(v) && v != null }
  )

  resource_location = try(var.advanced_options["location"], var.location)

  time_offset = try(var.advanced_options["time_offset"], "10h")

  resource_tags = merge(
    {
      deployedBy   = "Terraform"
      managedBy    = "Buun Group"
      compliance   = "none"
      owner        = "devops@buungroup.com"
      lifecycle    = "persistent"
      createdAt    = formatdate("YYYY-MM-DD'T'HH:mm:ss'Z'", timeadd(timestamp(), local.time_offset))
    },
    try(var.advanced_options["tags"], {}),
    var.tags
  )
} 