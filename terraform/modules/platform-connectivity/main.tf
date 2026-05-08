################################################################################
# modules/platform-connectivity
#
# SCAFFOLD. Resources scoped to the connectivity subscription.
# Intended contents (TODO):
#   - Hub virtual network + subnets (AzureFirewallSubnet, AzureBastionSubnet,
#     GatewaySubnet, dns-inbound, dns-outbound)
#   - Azure Firewall (Premium) + policy
#   - Azure Bastion (Standard)
#   - Private DNS zones + VNet links for common PaaS services
#   - DDoS protection plan (optional)
################################################################################

resource "azurerm_resource_group" "connectivity" {
  name     = "rg-${var.prefix}-hub-${var.location}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.prefix}-hub-${var.location}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.hub_address_space
  tags                = var.tags
}

# TODO: azurerm_subnet.{firewall,bastion,gateway,dns_inbound,dns_outbound}
# TODO: azurerm_firewall_policy.this + azurerm_firewall.this
# TODO: azurerm_bastion_host.this
# TODO: azurerm_private_dns_zone.* + azurerm_private_dns_zone_virtual_network_link.*
