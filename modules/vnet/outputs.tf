output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "List of subnet names"
  value       = [for k, v in azurerm_subnet.this : v.name]
}

output "nsg_ids" {
  description = "Map of subnet names to their NSG IDs"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
