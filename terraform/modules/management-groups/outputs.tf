output "management_group_ids" {
  description = "Resource IDs of every MG created by this module, keyed by role."
  value = {
    root         = azurerm_management_group.root.id
    platform     = azurerm_management_group.platform.id
    landingzones = azurerm_management_group.landingzones.id
    itar         = azurerm_management_group.itar.id
    non_itar     = azurerm_management_group.non_itar.id
  }
}

output "management_group_names" {
  description = "Stable management group names (the unqualified IDs), keyed by role."
  value = {
    root         = azurerm_management_group.root.name
    platform     = azurerm_management_group.platform.name
    landingzones = azurerm_management_group.landingzones.name
    itar         = azurerm_management_group.itar.name
    non_itar     = azurerm_management_group.non_itar.name
  }
}
