terraform {
  required_version = ">= 1.15"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
    }
  }
}

provider "azuread" {}

# Default azurerm provider — used for tenant-wide objects (management groups,
# policy assignments). Authenticates with the SP in creds.tfvars and targets
# the subscription supplied via ARM_SUBSCRIPTION_ID for any subscription-
# scoped data sources.
provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    template_deployment {
      delete_nested_items_during_deletion = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = true
    }
    virtual_machine_scale_set {
      force_delete = true
    }
  }
}

# ---------------------------------------------------------------------------
# Subscription-scoped provider aliases.
#
# Each platform module deploys into its own subscription. Terraform can't
# toggle providers conditionally, so each alias falls back to the default
# subscription when its target sub isn't supplied yet — modules using the
# alias are guarded by `count` on the corresponding deploy_* feature flag.
# ---------------------------------------------------------------------------

provider "azurerm" {
  alias           = "identity"
  subscription_id = coalesce(var.subscriptions.identity, var.ARM_SUBSCRIPTION_ID)
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = coalesce(var.subscriptions.management, var.ARM_SUBSCRIPTION_ID)
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = coalesce(var.subscriptions.connectivity, var.ARM_SUBSCRIPTION_ID)
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  features {}
}