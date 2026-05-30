output "github_actions_deploy_client_id" {
  description = "Set this as GitHub Environment variable AZURE_CLIENT_ID."
  value       = azurerm_user_assigned_identity.github_actions_deploy.client_id
}

output "github_actions_deploy_principal_id" {
  description = "Principal ID / object ID of the GitHub Actions user-assigned managed identity."
  value       = azurerm_user_assigned_identity.github_actions_deploy.principal_id
}


output "github_actions_push_client_id" {
  description = "Set this as GitHub Environment variable AZURE_CLIENT_ID."
  value       = azurerm_user_assigned_identity.github_actions_push.client_id
}

output "github_actions_push_principal_id" {
  description = "Principal ID / object ID of the GitHub Actions user-assigned managed identity."
  value       = azurerm_user_assigned_identity.github_actions_push.principal_id
}
