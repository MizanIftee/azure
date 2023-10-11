terraform {
  required_providers {
    azurerm = {
      version = ">2.43"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.az_region
  tags     = var.tags
}