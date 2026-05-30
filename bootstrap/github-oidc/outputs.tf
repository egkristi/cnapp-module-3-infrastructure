output "name_prefix" {
  description = "Common name prefix used for this infrastructure instance."
  value       = var.name_prefix
}

output "location" {
  description = "Azure region used by the bootstrap resources."
  value       = var.location
}

output "tenant_id" {
  description = "Azure tenant ID."
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID."
  value       = data.azurerm_subscription.current.subscription_id
}

output "identity_resource_group_name" {
  description = "Resource group containing GitHub Actions managed identities."
  value       = azurerm_resource_group.identity.name
}

output "state_resource_group_name" {
  description = "Resource group containing Terraform state storage."
  value       = azurerm_resource_group.state.name
}

output "state_storage_account_name" {
  description = "Storage account used for Terraform state."
  value       = azurerm_storage_account.state.name
}

output "state_containers" {
  description = "Terraform state containers per environment."
  value = {
    for env, container in azurerm_storage_container.state : env => container.name
  }
}

output "environment_resource_groups" {
  description = "Environment resource groups per environment."
  value = {
    for env, rg in azurerm_resource_group.environment : env => rg.name
  }
}

output "environment_aks_resource_groups" {
  description = "Environment resource groups per environment."
  value = {
    for env, rg in azurerm_resource_group.environment_aks : env => rg.name
  }
}

output "plan_identities" {
  description = "Read-only GitHub Actions plan managed identity details per environment."
  value = {
    for env, identity in azurerm_user_assigned_identity.plan : env => {
      name         = identity.name
      client_id    = identity.client_id
      principal_id = identity.principal_id
      resource_id  = identity.id
    }
  }
}

output "apply_identities" {
  description = "Write-capable GitHub Actions apply managed identity details per environment."
  value = {
    for env, identity in azurerm_user_assigned_identity.apply : env => {
      name         = identity.name
      client_id    = identity.client_id
      principal_id = identity.principal_id
      resource_id  = identity.id
    }
  }
}

output "github_environment_variable_reference" {
  description = "Values to copy into GitHub repository or environment variables."
  value = {
    repository_variables = {
      AZURE_TENANT_ID          = data.azurerm_client_config.current.tenant_id
      AZURE_SUBSCRIPTION_ID    = data.azurerm_subscription.current.subscription_id
      LOCATION                 = var.location
      TF_STATE_RESOURCE_GROUP  = azurerm_resource_group.state.name
      TF_STATE_STORAGE_ACCOUNT = azurerm_storage_account.state.name
    }

    dev_environment_variables = {
      AZURE_PLAN_CLIENT_ID  = azurerm_user_assigned_identity.plan["dev"].client_id
      AZURE_APPLY_CLIENT_ID = azurerm_user_assigned_identity.apply["dev"].client_id
      RESOURCE_GROUP_NAME   = local.environment_resource_group_names["dev"]
      TF_STATE_CONTAINER    = azurerm_storage_container.state["dev"].name
    }

    prod_environment_variables = {
      AZURE_PLAN_CLIENT_ID  = azurerm_user_assigned_identity.plan["prod"].client_id
      AZURE_APPLY_CLIENT_ID = azurerm_user_assigned_identity.apply["prod"].client_id
      RESOURCE_GROUP_NAME   = local.environment_resource_group_names["prod"]
      TF_STATE_CONTAINER    = azurerm_storage_container.state["prod"].name
    }
  }
}
