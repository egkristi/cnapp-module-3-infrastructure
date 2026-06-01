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

output "github_deploy_client_id" {
  description = "Set this as GitHub Environment variable AZURE_DEPLOY_CLIENT_ID."
  value       = module.federated_id_for_deployment.github_actions_deploy_client_id
}

output "github_push_client_id" {
  description = "Set this as GitHub Environment variable AZURE_PUSH_CLIENT_ID."
  value       = module.federated_id_for_deployment.github_actions_push_client_id
}

output "new_acr_name" {
  description = "Name of the new Azure Container Registry."
  value       = module.container_registry.name
}

output "new_acr_id" {
  description = "ID of the new Azure Container Registry."
  value       = module.container_registry.id
}

output "new_acr_login_server" {
  description = "Login server URL of the new Azure Container Registry."
  value       = module.container_registry.login_server
}

output "app_gateway_for_containers_name" {
  description = "Application Gateway for Containers name."
  value       = module.app_gateway_for_containers.name
}

output "app_gateway_for_containers_frontend_name" {
  description = "Application Gateway for Containers frontend name."
  value       = module.app_gateway_for_containers.frontend_name
}

output "environment_aks_resource_groups" {
  description = "Environment resource groups per environment."
  value       = data.azurerm_resource_group.environment_aks.name
}

output "alb_identity_id" {
  description = "Resource ID of the ALB Controller managed identity."
  value       = module.app_gateway_for_containers.alb_identity_id
}

output "key_vault_secrets_provider_identity_object_id" {
  value = module.aks_cluster.key_vault_secrets_provider_identity_object_id
}
