resource "azurerm_private_dns_zone" "postgres_internal_dns_zone" {
  name                = "example.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_zone_link" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_internal_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.cloud_network.id
  resource_group_name   = var.resource_group_name
  depends_on            = [azurerm_subnet.subnet_postgres]
}
