output "resource_group_name" {
  description = "Created resource group name."
  value       = module.resource_group.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = module.container_registry.name
}

output "acr_id" {
  description = "ID of the Azure Container Registry."
  value       = module.container_registry.id
}

output "acr_login_server" {
  description = "Login server URL of the Azure Container Registry."
  value       = module.container_registry.login_server
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = module.key_vault.vault_uri
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.aks_cluster.name
}

output "aks_cluster_id" {
  description = "AKS cluster ID."
  value       = module.aks_cluster.id
}

output "alb_identity_client_id" {
  description = "Client ID of the ALB Controller managed identity."
  value       = module.app_gateway_for_containers.alb_identity_client_id
}

output "alb_identity_principal_id" {
  description = "Principal ID of the ALB Controller managed identity."
  value       = module.app_gateway_for_containers.alb_identity_principal_id
}
