output "management_group_ids" {
  description = "Resource IDs of the management groups created by this configuration."
  value       = module.management_groups.management_group_ids
}

output "tenant_id" {
  description = "Azure AD tenant ID Terraform is operating in."
  value       = data.azurerm_client_config.current.tenant_id
}
