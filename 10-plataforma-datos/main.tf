locals {
  base         = "${var.project}-${var.environment}-${var.unique_suffix}"
  sql_location = coalesce(var.sql_location, var.location)
  tags = {
    project     = var.project
    environment = var.environment
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "data" {
  name     = "rg-${local.base}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_key_vault" "data" {
  name                       = "kv-${local.base}"
  location                   = azurerm_resource_group.data.location
  resource_group_name        = azurerm_resource_group.data.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  tags                       = local.tags
}

resource "azurerm_role_assignment" "kv_secrets" {
  scope                = azurerm_key_vault.data.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "random_password" "sql_admin" {
  length      = 24
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

resource "azurerm_key_vault_secret" "sql_admin" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = azurerm_key_vault.data.id
  depends_on   = [azurerm_role_assignment.kv_secrets]
}

moved {
  from = azurerm_mssql_database.main
  to   = azurerm_mssql_database.this["ventas"]
}

module "sql" {
  source              = "../modules/sql-database"
  name                = "sql-${local.base}"
  resource_group_name = azurerm_resource_group.data.name
  location            = local.sql_location
  admin_login         = "sqladmin${var.unique_suffix}"
  admin_password      = random_password.sql_admin.result
  databases           = var.databases
  tags                = local.tags
}

moved {
  from = azurerm_mssql_server.data
  to   = module.sql.azurerm_mssql_server.this
}

moved {
  from = azurerm_mssql_database.this
  to   = module.sql.azurerm_mssql_database.this
}
