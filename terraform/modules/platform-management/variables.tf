variable "prefix" {
  description = "Naming prefix."
  type        = string
}

variable "location" {
  description = "Azure region for the management platform resources."
  type        = string
}

variable "log_retention_days" {
  description = "Retention in days for the central Log Analytics workspace."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
