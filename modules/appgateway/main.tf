locals {
  backend_probe_name = "${var.vnet_name}-probe"
  http_setting_name  = "${var.vnet_name}-be-htst"
  public_ip_name     = "${var.vnet_name}-pip"
}

resource "azurerm_public_ip" "example" {
  name                = local.public_ip_name
  resource_group_name = var.resourcegroup.name
  location            = var.resourcegroup.location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "network" {
  depends_on          = [azurerm_public_ip.example]
  name                = "example-appgateway"
  resource_group_name = var.resourcegroup.name
  location            = var.resourcegroup.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id.[0].value
  }

  dynamic "frontend_port" {
    for_each = appservice_host
    content {
      name = "${var.vnet_name}-${frontend_port.value.name}-feport"
      port = "808${frontend_port.key}"
    }
  }

  frontend_ip_configuration {
    name                 = "${var.vnet_name}-feip"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  dynamic "backend_address_pool" {
    for_each = appservice_host
    content {
      name  = "${var.vnet_name}-${backend_address_pool.value.name}-beap"
      fqdns = [backend_address_pool.value.default_site_hostname]
    }
  }

  probe {
    name                                      = local.backend_probe_name
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 120
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      body        = "Welcome"
      status_code = [200, 399]
    }
  }

  backend_http_settings {
    name                                = local.http_setting_name
    probe_name                          = local.backend_probe_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 120
    pick_host_name_from_backend_address = true
  }

  dynamic "http_listener" {
    for_each = appservice_host
    content {
      name                           = "${var.vnet_name}-${http_listener.value.name}-httplstn"
      frontend_ip_configuration_name = "${var.vnet_name}-feip"
      frontend_port_name             = "${var.vnet_name}-${http_listener.value.name}-feport"
      protocol                       = "Http"
    }
  }

  dynamic "request_routing_rule" {
    for_each = appservice_host
    content {
      name                       = "${var.vnet_name}-${request_routing_rule.value.name}-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "${var.vnet_name}-${request_routing_rule.value.name}-httplstn"
      backend_address_pool_name  = "${var.vnet_name}-${request_routing_rule.value.name}-beap"
      backend_http_settings_name = local.http_setting_name
    }
  }
}