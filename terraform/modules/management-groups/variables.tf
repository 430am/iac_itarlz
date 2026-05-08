variable "tenant_root_mg_id" {
  description = "Resource ID of the tenant root management group (typically /providers/Microsoft.Management/managementGroups/<tenant_id>)."
  type        = string
}

variable "mg_ids" {
  description = "Stable management group names keyed by role."
  type = object({
    root         = string
    platform     = string
    landingzones = string
    itar         = string
    non_itar     = string
  })
}

variable "mg_display_names" {
  description = "Human-friendly display names matching mg_ids."
  type = object({
    root         = string
    platform     = string
    landingzones = string
    itar         = string
    non_itar     = string
  })
}

variable "subscriptions" {
  description = "Subscription IDs to place under each management group. Optional fields are skipped during initial bootstrap."
  type = object({
    identity     = optional(string)
    management   = optional(string)
    connectivity = optional(string)
    itar         = optional(list(string), [])
    non_itar     = optional(list(string), [])
  })
  default = {}
}
