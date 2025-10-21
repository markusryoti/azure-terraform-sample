# Not needed if the Resource Provider is already registered for the subscription
# resource "azurerm_resource_provider_registration" "network_registration" {
#   name = "Microsoft.Network"
# }

resource "azurerm_virtual_network" "cloud_network" {
  name                = "cloud-network"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  # # Uncomment the line below if Resource Provider registration is needed
  #   depends_on = [azurerm_resource_provider_registration.network_registration]
}

resource "azurerm_subnet" "subnet_public" {
  name                 = "subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloud_network.name

  # 10.0.1.0 - 10.0.1.255 (256 IP's)
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_container_apps" {
  name                 = "subnet-container-apps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloud_network.name

  # 10.0.2.0 - 10.0.3.255 (512 IP's)
  address_prefixes = ["10.0.2.0/23"]

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "subnet_postgres" {
  name                 = "subnet-postgres"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloud_network.name

  # 10.0.4.0 - 10.0.4.255 (256 IP's)
  address_prefixes  = ["10.0.4.0/24"]
  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
