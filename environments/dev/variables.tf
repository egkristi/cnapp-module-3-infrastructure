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

variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique Key Vault name."
  type        = string
}

variable "key_vault_administrator_principal_ids" {
  description = "Principal IDs that should administer the Key Vault."
  type        = list(string)
  default     = []
}

variable "key_vault_secrets_user_principal_ids" {
  description = "Principal IDs that should read secrets from the Key Vault."
  type        = list(string)
  default     = []
}
