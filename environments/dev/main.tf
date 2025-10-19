terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  subscription_id                 = "1f660e91-05dc-499a-b1ea-85b64df56c22"
  features {}
}

resource "azurerm_resource_group" "cloud_resources" {
  name     = "cloud-resources"
  location = "North Europe"
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.cloud_resources.name
  location            = azurerm_resource_group.cloud_resources.location
}

module "acr" {
  source              = "../../modules/acr"
  resource_group_name = azurerm_resource_group.cloud_resources.name
  location            = azurerm_resource_group.cloud_resources.location
}

module "containerapps_env" {
  source              = "../../modules/containerapps-env"
  resource_group_name = azurerm_resource_group.cloud_resources.name
  location            = azurerm_resource_group.cloud_resources.location
  subnet_id           = module.network.backend_subnet_id
}

module "nginx_app" {
  source              = "../../modules/containerapp"
  capp_environment_id = module.containerapps_env.container_apps_env_id
  resource_group_name = azurerm_resource_group.cloud_resources.name
}
