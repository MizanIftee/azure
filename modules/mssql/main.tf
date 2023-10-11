resource "azurerm_sql_server" "tfrg" {
    name                         = var.sql_server_name
    resource_group_name          = var.resourcegroup.name
    location                     = var.resourcegroup.location
    version                      = "12.0"
    administrator_login          = var.admin_username
    administrator_login_password = var.admin_password
}

resource "azurerm_sql_database" "tfrg" {
    name                = var.sql_db_name
    resource_group_name = var.resourcegroup.name
    location            = var.resourcegroup.location
    server_name         = azurerm_sql_server.tfrg.name

    edition             = "Basic"
}

resource "azurerm_sql_firewall_rule" "tfrg" {
    name                = "Allow All Azure Service"
    resource_group_name = var.resourcegroup.name
    server_name         = azurerm_sql_server.tfrg.name
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "0.0.0.0"
}
