// General
location = "norwayeast"
// Replace cnapp with your username:
// name_prefix = "<your username>"
name_prefix = "cnappuser6"

// Key vault
key_vault_administrator_principal_ids = [
  "fb6f65ab-53bc-4bb0-9603-e6f3cb963c0a"
]

key_vault_secrets_user_principal_ids = []

aks_node_count = 2
aks_vm_size    = "Standard_D2s_v3"


# Must be lowercase alphanumeric only. No hyphens.
# The module will create something like cnappdevabcdeacr.
acr_sku           = "Standard"
acr_admin_enabled = false

// Network variables
vnet_address_space = ["10.50.0.0/16"]

aks_subnet_name             = "snet-aks-dev"
aks_subnet_address_prefixes = ["10.50.0.0/22"]

agfc_subnet_name             = "snet-agfc-dev"
agfc_subnet_address_prefixes = ["10.50.4.0/24"]

// Application Gateway for Containers identities
alb_controller_namespace = "azure-alb-system"

github_organization = "egkristi"
// Replace repo with your forked module 2 repo name
github_repository   = "cnapp-module-2-application"
github_environments = ["dev", "prod"]
