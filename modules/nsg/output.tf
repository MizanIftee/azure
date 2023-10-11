output "nsg_id" {
  description = "The id of the newly created NSG"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  description = "The id of the newly created NSG"
  value       = azurerm_network_security_group.nsg.name
}
