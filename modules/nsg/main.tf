resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "adc" {
  for_each                  = var.subnets 
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
}