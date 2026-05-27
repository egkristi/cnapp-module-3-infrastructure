module "resource_group" {
  source = "../../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


module "federated_id_for_deployment" {
  source = "../../modules/federated-id-for-deployment"

  name                = var.identity_name
  location            = var.location
  resource_group_name = var.resource_group_name

  github_environments = var.github_environments
  github_repository   = var.github_repository
  github_organization = var.github_organization

  role_definition_name = var.role_definition_name

  tags = merge(var.tags, {
    service = "federated-id-for-deployment
  })
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                = var.key_vault_name
  location            = var.location
  resource_group_name = module.resource_group.name
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

  name                = var.vnet_name
  location            = var.location
  resource_group_name = module.resource_group.name

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

  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.aks_dns_prefix

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

  name                = var.agfc_name
  location            = var.location
  resource_group_name = module.resource_group.name

  frontend_name         = var.agfc_frontend_name
  association_name      = var.agfc_association_name
  association_subnet_id = module.network.agfc_subnet_id

  alb_identity_name            = var.alb_identity_name
  aks_oidc_issuer_url          = module.aks_cluster.oidc_issuer_url
  aks_node_resource_group_name = module.aks_cluster.node_resource_group
  alb_controller_namespace     = var.alb_controller_namespace

  tags = merge(var.tags, {
    service = "app-gateway-for-containers"
  })
}

data "azurerm_container_registry" "existing" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = data.azurerm_container_registry.existing.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_cluster.kubelet_identity_object_id
}
