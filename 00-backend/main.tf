locals {
  tags = {
    project     = var.project
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate-${var.project}-${var.unique_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "sttf${var.project}${var.unique_suffix}"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "state_rw" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

output "resource_group_name" { value = azurerm_resource_group.tfstate.name }
output "storage_account_name" { value = azurerm_storage_account.tfstate.name }
