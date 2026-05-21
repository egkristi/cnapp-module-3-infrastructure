variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
  }
}
