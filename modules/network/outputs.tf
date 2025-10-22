output "public_subnet_id" {
  value = azurerm_subnet.subnet_public.id
}

output "container_apps_subnet_id" {
  value = azurerm_subnet.subnet_container_apps.id
}

output "postgres_subnet_id" {
  value = azurerm_subnet.subnet_postgres.id
}

output "postgres_private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_internal_dns_zone.id
}

output "postgres_private_dns_zone_link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.postgres_dns_zone_link.id
}
