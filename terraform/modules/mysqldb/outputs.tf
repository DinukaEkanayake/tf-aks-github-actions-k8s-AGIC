output "username" {
  value = azurerm_mysql_flexible_server.mysql_db.administrator_login
}
output "is_public_access" {
  value = azurerm_mysql_flexible_server.mysql_db.public_network_access_enabled
}
output "mysqldb_vnet_link" {
  value = azurerm_private_dns_zone_virtual_network_link.mysqldb_net_link.name
}