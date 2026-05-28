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

variable "github_organization" {
  description = "GitHub organization or username."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "tags" {
  description = "Tags applied to bootstrap resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
  }
}
