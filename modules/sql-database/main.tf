resource "azurerm_mssql_server" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "this" {
  for_each             = var.databases
  name                 = "sqldb-${each.key}"
  server_id            = azurerm_mssql_server.this.id
  sku_name             = each.value.sku_name
  storage_account_type = "Local"
  tags                 = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
