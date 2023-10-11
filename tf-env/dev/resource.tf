resource "azurerm_storage_account" "workspace-sa" {
  name                     = var.datalake_sa_name
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  depends_on = [module.rg, module.virtual-network, module.key-vault]
}