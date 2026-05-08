################################################################################
# modules/activity-log-diagnostics
#
# Creates a subscription-scoped diagnostic setting on each supplied
# subscription that streams every Activity Log category to the central
# Log Analytics workspace in the management subscription.
#
# Notes
# -----
# * `azurerm_monitor_diagnostic_setting` targets ARM directly via
#   `target_resource_id`, so a single provider configuration can write
#   settings into multiple subscriptions provided the SP has the
#   `Monitoring Contributor` role on each target subscription.
# * Categories listed below are the full set of subscription-level
#   Activity Log categories as of azurerm v4.
################################################################################

locals {
  activity_log_categories = [
    "Administrative",
    "Security",
    "ServiceHealth",
    "Alert",
    "Recommendation",
    "Policy",
    "Autoscale",
    "ResourceHealth",
  ]

  subscription_ids = toset(compact(var.subscription_ids))
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  for_each = local.subscription_ids

  name                       = "send-activity-log-to-law"
  target_resource_id         = "/subscriptions/${each.value}"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = local.activity_log_categories
    content {
      category = enabled_log.value
    }
  }
}
