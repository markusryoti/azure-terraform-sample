variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string

}

variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use for the Container Apps environment."
  type        = string
}
