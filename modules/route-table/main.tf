resource "azurerm_route_table" "main" {
  name                = "${var.name}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }


  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "rt-association" {
  for_each       = var.subnets
  route_table_id = azurerm_route_table.main.id
  subnet_id      = each.value
}