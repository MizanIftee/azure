# https://github.com/Azure/ terraform-azurerm-vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group.name
  location            = var.vnet_location != null ? var.vnet_location : var.resource_group.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_id != "" ? [1] : []

    content {
      id     = var.ddos_id
      enable = true
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each                                       = var.subnets
  name                                           = "${var.subnet_prefix}${each.key}"
  resource_group_name                            = var.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [each.value]
  service_endpoints                              = lookup(var.subnet_service_endpoints, each.key, null)
  enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, each.key, false)
  enforce_private_link_service_network_policies  = lookup(var.subnet_enforce_private_link_service_network_policies, each.key, false)
}
