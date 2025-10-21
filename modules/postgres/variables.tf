variable "database_server_name" {
  description = "The name of the PostgreSQL Flexible Server to create."
  type        = string
}

variable "database_name" {
  description = "The name of the PostgreSQL database to create."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the PostgreSQL Flexible Server."
  type        = string
}

variable "location" {
  description = "The location in which to create the PostgreSQL Flexible Server."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use for the PostgreSQL Flexible Server."
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to link with the PostgreSQL Flexible Server."
  type        = string
}

