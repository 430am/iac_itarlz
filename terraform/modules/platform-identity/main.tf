################################################################################
# modules/platform-identity
#
# SCAFFOLD. Resources scoped to the identity subscription.
# Intended contents (TODO):
#   - Managed HSM (azurerm_key_vault_managed_hardware_security_module)
#   - HSM role assignments + RBAC
#   - Private endpoint into the connectivity hub for HSM data plane
#   - Diagnostic settings -> central Log Analytics workspace
################################################################################

resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.prefix}-identity-${var.location}"
  location = var.location
  tags     = var.tags
}

# TODO: azurerm_key_vault_managed_hardware_security_module.this { ... }
