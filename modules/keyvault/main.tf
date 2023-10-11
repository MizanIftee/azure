data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "${var.name}"
  location                    = var.resource_group.location
  resource_group_name         = var.resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.purge_protection
  sku_name                    = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions         = ["Create", "Delete", "Get", "Backup", "Decrypt", "Encrypt", "Import", "List", "Purge", "Recover", "Restore", "Sign", "Update", "Verify"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
    storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]

  }

  /*   network_acls {
    bypass = "AzureServices"
  }
 */
  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }

  tags = var.tags
}