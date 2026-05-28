variable "name_prefix" {
  description = "Common short prefix used to make this infrastructure instance unique."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,14}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-16 characters, start with a letter, end with a letter or number, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "location" {
  description = "Azure region for bootstrap resources."
  type        = string
}

variable "identity_resource_group_name" {
  description = "Resource group for GitHub Actions managed identities."
  type        = string
}

variable "state_resource_group_name" {
  description = "Resource group for Terraform state storage."
  type        = string
}

variable "state_storage_account_name" {
  description = "Globally unique Azure Storage Account name for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.state_storage_account_name))
    error_message = "state_storage_account_name must be 3-24 lowercase letters and numbers."
  }
}

variable "github_organization" {
  description = "GitHub organization or username."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "environments" {
  description = "Environment-specific bootstrap configuration."
  type = map(object({
    resource_group_name  = string
    state_container_name = string
    plan_identity_name  = string
    apply_identity_name = string
  }))

  validation {
    condition = alltrue([
      for env_name, env in var.environments :
      contains(["dev", "prod"], env_name)
    ])
    error_message = "Only dev and prod are expected environment keys."
  }
}

variable "tags" {
  description = "Tags applied to bootstrap resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
  }
}
