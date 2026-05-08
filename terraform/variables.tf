################################################################################
# Authentication / provider inputs
#
# These are passed in from environments/creds.tfvars and are also exported as
# ARM_* environment variables by the wrapper used to invoke Terraform.
################################################################################

variable "ARM_SUBSCRIPTION_ID" {
  description = "Default Azure subscription used by the root azurerm provider (the deployment / connectivity sub is fine)."
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_ID" {
  description = "Service principal client (application) ID."
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  description = "Service principal client secret."
  type        = string
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  description = "Azure AD tenant ID."
  type        = string
  sensitive   = true
}

variable "CURRENT_IP_ADDRESS" {
  description = "Public IP / CIDR of the operator running Terraform. Used for any temporary management allow-listing (e.g. bastion, KV firewall)."
  type        = string
  default     = "0.0.0.0/32"
}

################################################################################
# Naming / tagging
################################################################################

variable "prefix" {
  description = "Short organisation prefix (3-6 chars) used in management group IDs and resource names. Lowercase, no special chars."
  type        = string
  default     = "alz"

  validation {
    condition     = can(regex("^[a-z0-9]{2,6}$", var.prefix))
    error_message = "prefix must be 2-6 lowercase alphanumeric characters."
  }
}

variable "default_tags" {
  description = "Tags applied to every resource created by this configuration."
  type        = map(string)
  default = {
    managed_by = "terraform"
    workload   = "landing-zone"
  }
}

################################################################################
# Region selection
################################################################################

variable "primary_location" {
  description = "Primary Azure region for platform resources (hub network, log analytics, etc.). Azure Commercial only."
  type        = string
  default     = "eastus"
}

variable "secondary_location" {
  description = "Secondary Azure region for platform DR / paired services. Azure Commercial only."
  type        = string
  default     = "westus2"
}

# Allowed locations enforced by the ITAR policy assignment.
# Azure Commercial US regions only — Gov/DoD intentionally excluded.
variable "itar_allowed_locations" {
  description = "Azure regions permitted for ITAR workloads. US commercial regions only."
  type        = list(string)
  default = [
    "eastus",
    "eastus2",
    "centralus",
    "northcentralus",
    "southcentralus",
    "westus",
    "westus2",
    "westus3",
    "westcentralus",
  ]
}

variable "non_itar_allowed_locations" {
  description = "Azure regions permitted for non-ITAR workloads. Defaults to US commercial regions."
  type        = list(string)
  default = [
    "eastus",
    "eastus2",
    "centralus",
    "westus2",
    "westus3",
  ]
}

################################################################################
# Subscription IDs
#
# Bring-your-own-subscriptions model: subscriptions are created out-of-band
# (EA / MCA / manual) and their IDs are passed in here. The configuration
# places them under the correct management group and applies platform / LZ
# baselines to them.
#
# Set any value to null to skip placement / baseline for that slot during
# initial bootstrap.
################################################################################

variable "subscriptions" {
  description = "Map of platform and seed landing-zone subscription IDs to manage."
  type = object({
    identity     = optional(string)
    management   = optional(string)
    connectivity = optional(string)
    itar         = optional(list(string), [])
    non_itar     = optional(list(string), [])
  })
  default = {}
}

################################################################################
# Feature toggles — keep the scaffold lightweight; opt in to deployments.
################################################################################

variable "deploy_management" {
  description = "Deploy the management subscription baseline (Log Analytics, Sentinel, Defender for Cloud, etc.)."
  type        = bool
  default     = false
}

variable "deploy_connectivity" {
  description = "Deploy the connectivity subscription baseline (hub vnet, Azure Firewall, DNS, Bastion)."
  type        = bool
  default     = false
}

variable "deploy_identity" {
  description = "Deploy the identity subscription baseline (Managed HSM, identity supporting services)."
  type        = bool
  default     = false
}
