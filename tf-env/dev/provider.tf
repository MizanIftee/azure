data "azurerm_client_config" "current" {}

#Set the terraform required version
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      version = ">2.46"
    }
  }
backend "azurerm" {
    resource_group_name     = "rg-miz-deployment-info"
    storage_account_name    = "storagemizstate"
    container_name          = "dev"
    key                     = "dev-miz.tfstate" #variables not allowed here
}

}

# Configure the default Azure Provider
provider "azurerm" {
  subscription_id = var.subscriptions.main
  features {}
}





