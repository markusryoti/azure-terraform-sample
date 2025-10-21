resource "azurerm_postgresql_flexible_server" "postgres_server" {
  name                          = var.database_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "17"
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = "H@Sh1CoR3!"
  zone                          = "1"

  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "postgres_db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # prevent the possibility of accidental data loss
  #   lifecycle {
  #     prevent_destroy = true
  #   }
}
