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

output "alb_identity_client_id" {
  description = "Client ID of the ALB Controller managed identity."
  value       = azurerm_user_assigned_identity.alb_controller.client_id
}

output "alb_identity_principal_id" {
  description = "Principal ID of the ALB Controller managed identity."
  value       = azurerm_user_assigned_identity.alb_controller.principal_id
}

output "alb_identity_id" {
  description = "Resource ID of the ALB Controller managed identity."
  value       = azurerm_user_assigned_identity.alb_controller.id
}
