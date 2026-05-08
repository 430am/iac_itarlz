################################################################################
# modules/platform-management
#
# SCAFFOLD. Resources scoped to the management subscription.
# Intended contents (TODO):
#   - Log Analytics workspace (central)
#   - Microsoft Sentinel onboarding to the workspace
#   - Defender for Cloud plans + auto-provisioning
#   - Automation Account (update management / change tracking)
#   - Diagnostic settings policy assignments scoped to the root MG
################################################################################

resource "azurerm_resource_group" "management" {
  name     = "rg-${var.prefix}-mgmt-${var.location}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "central" {
  name                = "log-${var.prefix}-mgmt-${var.location}"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# TODO: azurerm_sentinel_log_analytics_workspace_onboarding.this { ... }
# TODO: azurerm_security_center_subscription_pricing.* (Defender plans)
# TODO: azurerm_automation_account.this { ... }
