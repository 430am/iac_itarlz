variable "log_analytics_workspace_id" {
  description = "Resource ID of the central Log Analytics workspace that will receive Activity Logs."
  type        = string
}

variable "subscription_ids" {
  description = "Subscription IDs that should ship their Activity Log to the central workspace. nulls are filtered out."
  type        = list(string)
  default     = []
}
