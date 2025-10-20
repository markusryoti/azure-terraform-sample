# resource "azurerm_resource_provider_registration" "capp_env_registration" {
#   name = "Microsoft.App"
# }

resource "azurerm_container_app_environment" "container_apps_env" {
  name                               = "containerapps-env"
  location                           = var.location
  resource_group_name                = var.resource_group_name
  infrastructure_subnet_id           = var.subnet_id
  infrastructure_resource_group_name = join("-", ["containerapps", "infra", "rg", var.location])

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }

  #   depends_on = [azurerm_resource_provider_registration.capp_env_registration]
}

output "container_apps_env_id" {
  value = azurerm_container_app_environment.container_apps_env.id
}
