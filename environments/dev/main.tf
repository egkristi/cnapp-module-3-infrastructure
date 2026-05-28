data "azurerm_resource_group" "environment" {
  name = "rg-${var.name_prefix}-dev"
}

data "azurerm_resource_group" "environment_aks" {
  name = "rg-${var.name_prefix}-dev-aks"
}

data "azurerm_resource_group" "environment_aks_nodes" {
  name = "rg-${var.name_prefix}-dev-aks-nodes"
}

module "federated_id_for_deployment" {
  source = "../../modules/federated-id-for-deployment"

  name                = "id-${var.name_prefix}-application"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.environment.name

  github_environments = var.github_environments
  github_repository   = var.github_repository
  github_organization = var.github_organization

  role_definition_name = var.role_definition_name
  name_prefix          = var.name_prefix
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                = "kv-${var.name_prefix}-dev"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.environment.name
  tenant_id           = var.tenant_id

  administrator_principal_ids = var.key_vault_administrator_principal_ids
  secrets_user_principal_ids  = var.key_vault_secrets_user_principal_ids

  purge_protection_enabled = false

  tags = merge(var.tags, {
    service = "key-vault"
  })
}

module "network" {
  source = "../../modules/network"

  name                = "vnet-${var.name_prefix}-dev"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.environment_aks.name

  address_space = var.vnet_address_space

  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes

  agfc_subnet_name             = var.agfc_subnet_name
  agfc_subnet_address_prefixes = var.agfc_subnet_address_prefixes

  tags = merge(var.tags, {
    service = "network"
  })
}

module "aks_cluster" {
  source = "../../modules/aks-cluster"

  name                     = "aks-${var.name_prefix}-dev"
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.environment_aks.name
  node_resource_group_name = data.azurerm_resource_group.environment_aks_nodes.name

  dns_prefix = "aks-${var.name_prefix}-dev"

  subnet_id = module.network.aks_subnet_id

  kubernetes_version = var.aks_kubernetes_version
  node_count         = var.aks_node_count
  vm_size            = var.aks_vm_size

  tags = merge(var.tags, {
    service = "aks"
  })
}

module "app_gateway_for_containers" {
  source = "../../modules/app-gw-for-containers"

  name                = "agfc-${var.name_prefix}-dev"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.environment_aks.name

  frontend_name         = "frontend-${var.name_prefix}-dev"
  association_name      = "assoc-${var.name_prefix}-dev"
  association_subnet_id = module.network.agfc_subnet_id

  alb_identity_name            = "id-alb-${var.name_prefix}-dev"
  aks_oidc_issuer_url          = module.aks_cluster.oidc_issuer_url
  aks_node_resource_group_name = module.aks_cluster.node_resource_group
  alb_controller_namespace     = var.alb_controller_namespace

  tags = merge(var.tags, {
    service = "app-gateway-for-containers"
  })
}

module "container_registry" {
  source = "../../modules/container-registry"

  name_prefix         = "${var.name_prefix}dev"
  resource_group_name = data.azurerm_resource_group.environment.name
  location            = var.location
  sku                 = var.acr_sku
  acr_admin_enabled   = var.acr_admin_enabled

  tags = merge(var.tags, {
    service = "container-registry"
  })
}

resource "azurerm_role_assignment" "aks_new_acr_pull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_cluster.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "deployment_key_vault_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.federated_id_for_deployment.principal_id
}
