output "log_analytics_workspace_id" {
  description = "Resource ID of the central Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.central.id
}

output "resource_group_id" {
  value = azurerm_resource_group.management.id
}
