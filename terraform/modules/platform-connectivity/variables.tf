variable "prefix" {
  description = "Naming prefix."
  type        = string
}

variable "location" {
  description = "Azure region for the hub network."
  type        = string
}

variable "hub_address_space" {
  description = "Address space CIDR blocks for the hub VNet."
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
