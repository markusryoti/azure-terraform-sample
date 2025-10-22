variable "storage_account_name" {
  description = "The name of the storage account to create."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
}

variable "location" {
  description = "The location in which to create the storage account."
  type        = string
}
