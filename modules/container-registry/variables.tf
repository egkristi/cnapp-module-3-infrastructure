variable "name_prefix" {
  type        = string
  description = "Prefix used for the Azure Container Registry name."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Azure Container Registry will be created."
}

variable "location" {
  type        = string
  description = "Azure region where the Azure Container Registry will be created."
}

variable "sku" {
  type        = string
  description = "SKU for the Azure Container Registry."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Whether the admin user is enabled for the Azure Container Registry."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Azure Container Registry."
  default     = {}
}
