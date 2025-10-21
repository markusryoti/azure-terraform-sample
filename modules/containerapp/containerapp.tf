resource "azurerm_container_app" "nginx" {
  name                         = var.app_name
  container_app_environment_id = var.capp_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  template {
    container {
      name   = var.container_name
      image  = var.image_name
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = var.public_ingress
    target_port      = var.container_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
