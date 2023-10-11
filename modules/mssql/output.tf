output "domain_name" {
   value  = azurerm_sql_server.tfrg.fully_qualified_domain_name
}

output "db_name" {
   value  = azurerm_sql_database.tfrg.name
}