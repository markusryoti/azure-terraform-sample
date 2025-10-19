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

  # 10.0.0.0 - 10.0.7.255
  address_prefixes = ["10.0.0.0/21"]
}

# Public IP
resource "azurerm_public_ip" "frontend_ip" {
  name                = "public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet" "subnet_backend" {
  name                 = "subnet-backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloud_network.name

  # 10.0.8.0 - 10.0.15.255
  address_prefixes = ["10.0.8.0/21"]

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

# NAT
resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-gateway-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = "nat-gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_subnet_nat_gateway_association" "backend_nat_assoc" {
  subnet_id      = azurerm_subnet.subnet_backend.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

resource "azurerm_nat_gateway_public_ip_association" "nat_public_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

output "public_subnet_id" {
  value = azurerm_subnet.subnet_public.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.subnet_backend.id
}
