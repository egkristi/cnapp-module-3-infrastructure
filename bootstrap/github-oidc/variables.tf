variable "subscription_id" {
  description = "The single Azure subscription ID used for all environments."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "location" {
  description = "Azure region for bootstrap resources."
  type        = string
  default     = "westeurope"
}

variable "github_organization" {
  description = "GitHub organization or user that owns the repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "github_environments" {
  description = "GitHub environments trusted by the managed identity."
  type        = set(string)
  default     = ["dev", "prod"]
}

variable "state_resource_group_name" {
  description = "Resource group for Terraform remote state."
  type        = string
  default     = "rg-tfstate"
}

variable "state_storage_account_name" {
  description = "Globally unique Azure Storage Account name for Terraform state. Must be 3-24 lowercase letters and numbers."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.state_storage_account_name))
    error_message = "state_storage_account_name must be 3-24 characters and contain only lowercase letters and numbers."
  }
}

variable "state_container_name" {
  description = "Blob container name for Terraform state files."
  type        = string
  default     = "tfstate"
}

variable "identity_resource_group_name" {
  description = "Resource group for the GitHub Actions managed identity."
  type        = string
  default     = "rg-github-oidc"
}

variable "identity_name" {
  description = "Single user-assigned managed identity used by GitHub Actions."
  type        = string
  default     = "id-github-terraform"
}

variable "role_definition_name" {
  description = "Azure RBAC role assigned to the managed identity. Narrow the scope/role for stricter setups."
  type        = string
  default     = "Contributor"
}

variable "tags" {
  description = "Common tags for bootstrap resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
    purpose    = "github-oidc-bootstrap"
  }
}
