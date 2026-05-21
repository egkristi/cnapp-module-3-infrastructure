output "azure_client_id" {
  description = "Set this as GitHub Environment variable AZURE_CLIENT_ID."
  value       = azurerm_user_assigned_identity.github_actions.client_id
}

output "azure_tenant_id" {
  description = "Set this as GitHub Environment variable AZURE_TENANT_ID."
  value       = var.tenant_id
}

output "azure_subscription_id" {
  description = "Set this as GitHub Environment variable AZURE_SUBSCRIPTION_ID."
  value       = var.subscription_id
}

output "state_resource_group_name" {
  description = "Remote state resource group name."
  value       = azurerm_resource_group.state.name
}

output "state_storage_account_name" {
  description = "Remote state storage account name."
  value       = azurerm_storage_account.state.name
}

output "state_container_name" {
  description = "Remote state storage container name."
  value       = azurerm_storage_container.state.name
}

output "backend_config_dev" {
  description = "Backend block values for environments/dev/backend.tf."
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    storage_account_name = azurerm_storage_account.state.name
    container_name       = azurerm_storage_container.state.name
    key                  = "dev.terraform.tfstate"
  }
}

output "backend_config_prod" {
  description = "Backend block values for environments/prod/backend.tf."
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    storage_account_name = azurerm_storage_account.state.name
    container_name       = azurerm_storage_container.state.name
    key                  = "prod.terraform.tfstate"
  }
}
