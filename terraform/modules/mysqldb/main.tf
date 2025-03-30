resource "azurerm_private_dns_zone" "mysqldb_private_dns_zone" {
  name                = "myapp.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysqldb_net_link" {
  name                  = "mysqldbVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.mysqldb_private_dns_zone.name
  virtual_network_id    = var.db_vnet_id
  resource_group_name   = var.resource_group_name
}
resource "azurerm_mysql_flexible_server" "mysql_db" {
  name                   = "mysqldbserver-${var.cluster_name}"
  resource_group_name    = var.resource_group_name
  location               = "centralus"
  delegated_subnet_id    = var.db_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.mysqldb_private_dns_zone.id
  administrator_login    = "mysqladmin"
  administrator_password = "Dinuka18"
  
  sku_name               = "B_Standard_B1ms"
  zone = "1"
  geo_redundant_backup_enabled = false
  storage {
    size_gb = 20
  }
  version                = "8.0.21"
  backup_retention_days  = 7
  # create_mode = "replica"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysqldb_net_link]
}

# resource "random_password" "mysql" {
#   length           = 0
#   special         = false
# }

resource "azurerm_mysql_flexible_database" "db" {
  name                = "myappdb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_db.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_private_endpoint" "mysql_pe" {
  name                = "db-mysql-pe"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.db_subnet_id

  private_service_connection {
    name                           = "db-mysql-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql_db.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
}

resource "azurerm_private_dns_a_record" "mysql_dns" {
  name                = azurerm_mysql_flexible_server.mysql_db.name
  zone_name           = azurerm_private_dns_zone.mysqldb_private_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.mysql_pe.private_service_connection.0.private_ip_address]
}
