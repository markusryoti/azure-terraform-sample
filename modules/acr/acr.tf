# resource "azurerm_resource_provider_registration" "acr_registration" {
#   name = "Microsoft.ContainerRegistry"
# }

resource "azurerm_container_registry" "acr" {
  name                = "markusRyotiContainerRegistry"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false

  #   depends_on = [azurerm_resource_provider_registration.acr_registration]
}
