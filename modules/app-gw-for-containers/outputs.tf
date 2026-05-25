output "id" {
  description = "Application Gateway for Containers resource ID."
  value       = azurerm_application_load_balancer.this.id
}

output "name" {
  description = "Application Gateway for Containers name."
  value       = azurerm_application_load_balancer.this.name
}

output "frontend_id" {
  description = "Application Gateway for Containers frontend ID."
  value       = azurerm_application_load_balancer_frontend.this.id
}

output "frontend_name" {
  description = "Application Gateway for Containers frontend name."
  value       = azurerm_application_load_balancer_frontend.this.name
}

output "association_id" {
  description = "Application Gateway for Containers association ID."
  value       = azurerm_application_load_balancer_subnet_association.this.id
}
