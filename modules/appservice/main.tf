resource "azurerm_app_service_plan" "tfrg" {
  name                = "${var.prefix}-svcplan"
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "tfrg" {
  name                = "${var.prefix}api"
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name
  app_service_plan_id = azurerm_app_service_plan.tfrg.id

  site_config {
    always_on                = "true"
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    EVENTS_SQLCONN = "Server=tcp:${var.domain_name},1433;Initial Catalog=${azurerm_sql_database.tfrg.name};Persist Security Info=False;User ID=${var.admin_username};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

}