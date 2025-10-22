terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.49.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  subscription_id                 = "1f660e91-05dc-499a-b1ea-85b64df56c22"
  features {}
}

resource "azurerm_resource_group" "rg_network" {
  name     = "rg-network"
  location = "North Europe"
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = azurerm_resource_group.rg_network.location
}

resource "azurerm_resource_group" "rg_acr" {
  name     = "rg-acr"
  location = "North Europe"
}

module "acr" {
  source              = "../../modules/acr"
  resource_group_name = azurerm_resource_group.rg_acr.name
  location            = azurerm_resource_group.rg_acr.location
}

resource "azurerm_resource_group" "rg_compute" {
  name     = "rg-compute"
  location = "North Europe"
}

module "containerapps_env" {
  source              = "../../modules/containerapps-env"
  resource_group_name = azurerm_resource_group.rg_compute.name
  location            = azurerm_resource_group.rg_compute.location
  subnet_id           = module.network.container_apps_subnet_id
}

module "frontend" {
  source              = "../../modules/containerapp"
  app_name            = "frontend"
  container_name      = "frontend-container"
  image_name          = "docker.io/nginx:latest"
  public_ingress      = true
  container_port      = 80
  capp_environment_id = module.containerapps_env.container_apps_env_id
  resource_group_name = azurerm_resource_group.rg_compute.name
}

module "backend" {
  source              = "../../modules/containerapp"
  app_name            = "backend"
  container_name      = "backend-container"
  image_name          = "docker.io/nginx:latest"
  public_ingress      = true
  container_port      = 80
  capp_environment_id = module.containerapps_env.container_apps_env_id
  resource_group_name = azurerm_resource_group.rg_compute.name
}

resource "azurerm_resource_group" "rg_storage" {
  name     = "rg-storage"
  location = "North Europe"
}

module "postgres" {
  source               = "../../modules/postgres"
  database_server_name = "markusryoti-example-psql-db"
  database_name        = "exampledb"
  resource_group_name  = azurerm_resource_group.rg_storage.name
  location             = azurerm_resource_group.rg_storage.location
  subnet_id            = module.network.postgres_subnet_id
  private_dns_zone_id  = module.network.postgres_private_dns_zone_id

  depends_on = [module.network.postgres_private_dns_zone_link_id]
}
