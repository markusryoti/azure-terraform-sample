variable "capp_environment_id" {
  description = "Container Apps Environment ID"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string
}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "image_name" {
  description = "The name of the the container image"
  type        = string
}

variable "public_ingress" {
  description = "Enable access from public internet"
  type        = bool
}

variable "container_port" {
  description = "The port that the container exposes"
  type        = number
}
