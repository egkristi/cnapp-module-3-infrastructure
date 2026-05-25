variable "name" {
  description = "Name of the virtual network."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the virtual network will be created."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet."
  type        = string
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefixes for the AKS subnet."
  type        = list(string)
}

variable "agfc_subnet_name" {
  description = "Name of the Application Gateway for Containers subnet."
  type        = string
}

variable "agfc_subnet_address_prefixes" {
  description = "Address prefixes for the Application Gateway for Containers subnet."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
