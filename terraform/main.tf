data "azurerm_client_config" "current" {}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

################################################################################
# Management group hierarchy
#
#   tenant root
#   └── <prefix>-root
#       ├── platform
#       │   ├── identity
#       │   ├── management
#       │   └── connectivity
#       └── landingzones
#           ├── itar
#           └── non-itar
################################################################################

module "management_groups" {
  source = "./modules/management-groups"

  tenant_root_mg_id = local.tenant_root_mg_id
  mg_ids            = local.mg_ids
  mg_display_names  = local.mg_display_names
  subscriptions     = var.subscriptions
}

################################################################################
# Opinionated baseline policies
################################################################################

module "policies" {
  source = "./modules/policies"

  management_group_ids = {
    root     = module.management_groups.management_group_ids.root
    itar     = module.management_groups.management_group_ids.itar
    non_itar = module.management_groups.management_group_ids.non_itar
  }

  itar_allowed_locations     = var.itar_allowed_locations
  non_itar_allowed_locations = var.non_itar_allowed_locations
}

################################################################################
# Platform subscription baselines (opt-in via deploy_* flags)
################################################################################

module "platform_identity" {
  source = "./modules/platform-identity"
  count  = var.deploy_identity && var.subscriptions.identity != null ? 1 : 0

  providers = {
    azurerm = azurerm.identity
  }

  prefix   = var.prefix
  location = var.primary_location
  tags     = local.tags
}

module "platform_management" {
  source = "./modules/platform-management"
  count  = var.deploy_management && var.subscriptions.management != null ? 1 : 0

  providers = {
    azurerm = azurerm.management
  }

  prefix   = var.prefix
  location = var.primary_location
  tags     = local.tags
}

module "platform_connectivity" {
  source = "./modules/platform-connectivity"
  count  = var.deploy_connectivity && var.subscriptions.connectivity != null ? 1 : 0

  providers = {
    azurerm = azurerm.connectivity
  }

  prefix   = var.prefix
  location = var.primary_location
  tags     = local.tags
}

################################################################################
# Subscription Activity Log -> central Log Analytics workspace
#
# Requires the management subscription (and its workspace) to be deployed.
# Iterates over every managed subscription \u2014 platform + landing zones \u2014 and
# enables a diagnostic setting that ships every Activity Log category to the
# central workspace.
################################################################################

module "activity_log_diagnostics" {
  source = "./modules/activity-log-diagnostics"
  count  = var.deploy_management && var.subscriptions.management != null ? 1 : 0

  log_analytics_workspace_id = module.platform_management[0].log_analytics_workspace_id

  subscription_ids = concat(
    compact([
      var.subscriptions.identity,
      var.subscriptions.management,
      var.subscriptions.connectivity,
    ]),
    var.subscriptions.itar,
    var.subscriptions.non_itar,
  )
}