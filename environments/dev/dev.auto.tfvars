key_vault_administrator_principal_ids = [
  "d5e2cefe-2c10-41da-9035-77684e55a51e"
]

key_vault_secrets_user_principal_ids = []

// AKS variables
aks_cluster_name = "aks-cnapp-dev"
aks_dns_prefix   = "aks-cnapp-dev"

aks_node_count = 2
aks_vm_size    = "Standard_D2s_v3"

// Use existing Azure Container Registry
acr_name                = "markusscnapplab"
acr_resource_group_name = "markuss-cnapplab"

// Network variables
vnet_name          = "vnet-cnapp-dev"
vnet_address_space = ["10.50.0.0/16"]

aks_subnet_name             = "snet-aks-dev"
aks_subnet_address_prefixes = ["10.50.0.0/22"]

agfc_subnet_name             = "snet-agfc-dev"
agfc_subnet_address_prefixes = ["10.50.4.0/24"]

// Application Gateway for Containers
agfc_name             = "agfc-cnapp-dev"
agfc_frontend_name    = "frontend-cnapp-dev"
agfc_association_name = "assoc-cnapp-dev"

// Application Gateway for Containers identities
alb_identity_name        = "id-alb-cnapp-dev"
alb_controller_namespace = "azure-alb-system"

github_organization = "msilabben"
github_repository = "cnapp-module-2-application"
github_environments = ["dev", "prod"]
identity_name = "id-cnapp-application"
