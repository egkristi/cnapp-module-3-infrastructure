output "name" {
  description = "Name of the Azure Container Registry."
  value       = azurerm_container_registry.this.name
}

output "id" {
  description = "ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "Login server URL of the Azure Container Registry."
  value       = azurerm_container_registry.this.login_server
}
