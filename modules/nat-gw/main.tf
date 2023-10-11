locals {
  resource_name = "${var.env}-${var.resource_suffix}-${var.service}"
}

resource "azurerm_public_ip" "nat_pip" {
  name                = "${local.resource_name}-pip"
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${local.resource_name}-pip"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = "${local.resource_name}"
  location                = var.resourcegroup.location
  resource_group_name     = var.resourcegroup.name
  idle_timeout_in_minutes = 4
  sku_name                = "Standard"
  tags                    = var.tags
}


resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet-natgw" {
  for_each       = var.subnets
  nat_gateway_id = azurerm_nat_gateway.natgw.id
  subnet_id      = each.value
}