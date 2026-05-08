variable "prefix" {
  description = "Naming prefix."
  type        = string
}

variable "location" {
  description = "Azure region for the identity platform resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
