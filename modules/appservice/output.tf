output "webapp_site_credentials" {
  value = azurerm_app_service.tfrg.site_credential
}

output "webapp_test" {
  value = "https://${azurerm_app_service.tfrg.default_site_hostname}"
}

output "site_hostname" {
  value = azurerm_app_service.tfrg.default_site_hostname
}