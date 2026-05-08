output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "resource_group_id" {
  value = azurerm_resource_group.connectivity.id
}
