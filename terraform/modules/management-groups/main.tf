################################################################################
# modules/management-groups
#
# Builds the management group hierarchy and places caller-supplied
# subscriptions under the appropriate management groups.
#
#   tenant root
#   └── <prefix>-root
#       ├── platform                 (← identity, management, connectivity subs)
#       └── landingzones
#           ├── itar                 (← ITAR workload subscriptions)
#           └── non-itar             (← non-ITAR workload subscriptions)
################################################################################

# Top of the hierarchy created by this stack. Parented to the tenant root MG.
resource "azurerm_management_group" "root" {
  name                       = var.mg_ids.root
  display_name               = var.mg_display_names.root
  parent_management_group_id = var.tenant_root_mg_id
}

# ---- Tier 2: Platform vs Landing Zones -------------------------------------

resource "azurerm_management_group" "platform" {
  name                       = var.mg_ids.platform
  display_name               = var.mg_display_names.platform
  parent_management_group_id = azurerm_management_group.root.id

  # Identity, management, and connectivity subscriptions all live directly
  # under the platform MG (no per-role sub-MGs).
  subscription_ids = compact([
    var.subscriptions.identity,
    var.subscriptions.management,
    var.subscriptions.connectivity,
  ])
}

resource "azurerm_management_group" "landingzones" {
  name                       = var.mg_ids.landingzones
  display_name               = var.mg_display_names.landingzones
  parent_management_group_id = azurerm_management_group.root.id
}

# ---- Tier 3: Landing Zone leaf MGs -----------------------------------------

resource "azurerm_management_group" "itar" {
  name                       = var.mg_ids.itar
  display_name               = var.mg_display_names.itar
  parent_management_group_id = azurerm_management_group.landingzones.id
  subscription_ids           = var.subscriptions.itar
}

resource "azurerm_management_group" "non_itar" {
  name                       = var.mg_ids.non_itar
  display_name               = var.mg_display_names.non_itar
  parent_management_group_id = azurerm_management_group.landingzones.id
  subscription_ids           = var.subscriptions.non_itar
}
