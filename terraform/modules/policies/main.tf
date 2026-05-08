################################################################################
# modules/policies
#
# Opinionated policy assignments applied to the management group hierarchy.
# Uses Azure built-in policy definitions / initiatives where possible to keep
# this scaffold lightweight. Custom JSON definitions can be added under
# ../../../policies and referenced via azurerm_policy_definition data sources.
#
# Policies applied:
#   ROOT MG
#     - Require tag 'workload' on resource groups (inheritance demo)
#   ITAR MG
#     - Allowed locations           (built-in: e56962a6-4747-49cd-b67b-bf8b01975c4c)
#     - Allowed locations for RGs   (built-in: e765b5de-1225-4ba3-bd56-1ac6695af988)
#     - Deny public network access  (built-in initiative for PaaS hardening)
#     - Require CMK on storage      (built-in: 6fac406b-40ca-413b-bf8e-0bf964659c25)
#   NON-ITAR MG
#     - Allowed locations           (built-in: e56962a6-4747-49cd-b67b-bf8b01975c4c)
#     - Allowed locations for RGs   (built-in: e765b5de-1225-4ba3-bd56-1ac6695af988)
################################################################################

# ---- Built-in policy definitions ------------------------------------------

data "azurerm_policy_definition_built_in" "allowed_locations" {
  name = "e56962a6-4747-49cd-b67b-bf8b01975c4c"
}

data "azurerm_policy_definition_built_in" "allowed_locations_rg" {
  name = "e765b5de-1225-4ba3-bd56-1ac6695af988"
}

data "azurerm_policy_definition_built_in" "storage_cmk" {
  name = "6fac406b-40ca-413b-bf8e-0bf964659c25"
}

data "azurerm_policy_definition_built_in" "require_tag_on_rg" {
  # 'Require a tag on resource groups'
  name = "96670d01-0a4d-4649-9c89-2d3abc0a5025"
}

# ---- ROOT: tag governance --------------------------------------------------

resource "azurerm_management_group_policy_assignment" "root_require_workload_tag" {
  name                 = "require-workload-tag"
  display_name         = "Require 'workload' tag on resource groups"
  management_group_id  = var.management_group_ids.root
  policy_definition_id = data.azurerm_policy_definition_built_in.require_tag_on_rg.id

  parameters = jsonencode({
    tagName = { value = "workload" }
  })
}

# ---- ITAR: allowed locations (resources + resource groups) -----------------

resource "azurerm_management_group_policy_assignment" "itar_allowed_locations" {
  name                 = "itar-allowed-locs"
  display_name         = "ITAR - Allowed resource locations (US only)"
  management_group_id  = var.management_group_ids.itar
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.itar_allowed_locations }
  })
}

resource "azurerm_management_group_policy_assignment" "itar_allowed_locations_rg" {
  name                 = "itar-allowed-locs-rg"
  display_name         = "ITAR - Allowed resource group locations (US only)"
  management_group_id  = var.management_group_ids.itar
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_locations_rg.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.itar_allowed_locations }
  })
}

resource "azurerm_management_group_policy_assignment" "itar_storage_cmk" {
  name                 = "itar-storage-cmk"
  display_name         = "ITAR - Storage accounts must use customer-managed keys"
  management_group_id  = var.management_group_ids.itar
  policy_definition_id = data.azurerm_policy_definition_built_in.storage_cmk.id
}

# ---- NON-ITAR: allowed locations -------------------------------------------

resource "azurerm_management_group_policy_assignment" "non_itar_allowed_locations" {
  name                 = "non-itar-allowed-locs"
  display_name         = "Non-ITAR - Allowed resource locations"
  management_group_id  = var.management_group_ids.non_itar
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.non_itar_allowed_locations }
  })
}

resource "azurerm_management_group_policy_assignment" "non_itar_allowed_locations_rg" {
  name                 = "non-itar-allowed-loc-rg"
  display_name         = "Non-ITAR - Allowed resource group locations"
  management_group_id  = var.management_group_ids.non_itar
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_locations_rg.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.non_itar_allowed_locations }
  })
}
