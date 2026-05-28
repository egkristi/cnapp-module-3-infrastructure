output "shared_services_resource_group_name" {
  description = "Name of the shared services resource group."
  value       = module.shared_services_resource_group.name
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

output "existing_acr_name" {
  description = "Name of the existing Azure Container Registry."
  value       = data.azurerm_container_registry.existing.name
}

output "existing_acr_id" {
  description = "ID of the existing Azure Container Registry."
  value       = data.azurerm_container_registry.existing.id
}

output "existing_acr_login_server" {
  description = "Login server URL of the existing Azure Container Registry."
  value       = data.azurerm_container_registry.existing.login_server
}
