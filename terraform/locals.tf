locals {
  # ---------------------------------------------------------------------------
  # Management group IDs (stable, lowercase, prefix-scoped).
  # The tenant root group is *not* created by this configuration — it already
  # exists and is identified by the Azure AD tenant ID.
  # ---------------------------------------------------------------------------
  mg_ids = {
    root         = "${var.prefix}-root"
    platform     = "${var.prefix}-platform"
    landingzones = "${var.prefix}-landingzones"
    itar         = "${var.prefix}-lz-itar"
    non_itar     = "${var.prefix}-lz-non-itar"
  }

  mg_display_names = {
    root         = "${upper(var.prefix)} Root"
    platform     = "Platform"
    landingzones = "Landing Zones"
    itar         = "Landing Zones - ITAR"
    non_itar     = "Landing Zones - Non-ITAR"
  }

  tenant_root_mg_id = "/providers/Microsoft.Management/managementGroups/${data.azurerm_client_config.current.tenant_id}"

  # ---------------------------------------------------------------------------
  # Common tags merged into every resource.
  # ---------------------------------------------------------------------------
  tags = merge(var.default_tags, {
    deployment_prefix = var.prefix
  })
}
