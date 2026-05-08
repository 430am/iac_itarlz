variable "management_group_ids" {
  description = "Resource IDs of the MGs this module attaches policies to."
  type = object({
    root     = string
    itar     = string
    non_itar = string
  })
}

variable "itar_allowed_locations" {
  description = "Permitted Azure regions for ITAR workloads."
  type        = list(string)
}

variable "non_itar_allowed_locations" {
  description = "Permitted Azure regions for non-ITAR workloads."
  type        = list(string)
}
