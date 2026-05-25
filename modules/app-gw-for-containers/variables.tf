variable "name" {
  description = "Name of the Application Gateway for Containers resource."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Application Gateway for Containers will be created."
  type        = string
}

variable "frontend_name" {
  description = "Name of the Application Gateway for Containers frontend."
  type        = string
}

variable "association_name" {
  description = "Name of the Application Gateway for Containers subnet association."
  type        = string
}

variable "association_subnet_id" {
  description = "ID of the delegated subnet used by Application Gateway for Containers."
  type        = string
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
