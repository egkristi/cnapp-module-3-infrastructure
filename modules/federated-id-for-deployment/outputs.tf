output "azure_client_id" {
  description = "Set this as GitHub Environment variable AZURE_CLIENT_ID."
  value       = azurerm_user_assigned_identity.github_actions.client_id
}

output "github_actions_principal_id" {
  description = "Principal ID / object ID of the GitHub Actions user-assigned managed identity."
  value       = azurerm_user_assigned_identity.github_actions.principal_id
}
