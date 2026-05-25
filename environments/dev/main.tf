module "resource_group" {
  source = "../../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
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

module "aks_cluster" {
  source = "../../modules/aks-cluster"

  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version = var.aks_kubernetes_version
  node_count         = var.aks_node_count
  vm_size            = var.aks_vm_size

  tags = merge(var.tags, {
    service = "aks"
  })
}
