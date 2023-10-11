resource "azurerm_app_service_plan" "tfrg" {
  name                = var.appserviceplanname
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name
  kind                = var.kind
  reserved            = true

  sku {
    tier = var.tier
    size = var.size
  }
}

resource "azurerm_app_service" "tfrg" {
  name                = var.appservicename
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name
  app_service_plan_id = azurerm_app_service_plan.tfrg.id

  site_config {
    always_on                = "true"
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2015"
  }

  app_settings = {
    EVENTS_SQLCONN = "Server=tcp:${var.domain_name},1433;Initial Catalog=${var.sql_db_name};Persist Security Info=False;User ID=${var.admin_username};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

}