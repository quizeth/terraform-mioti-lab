output "resource_group_name" {
  value = azurerm_resource_group.data.name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.data.fully_qualified_domain_name
}

output "key_vault_id" {
  value = azurerm_key_vault.data.id
}

output "sql_admin_password" {
  value     = random_password.sql_admin.result
  sensitive = true
}
