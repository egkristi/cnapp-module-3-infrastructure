data "azurerm_subscription" "current" {}

resource "random_string" "state_suffix" {
  count = var.state_storage_account_name == null ? 1 : 0

  length  = 8
  upper   = false
  special = false
}

locals {
  state_storage_account_name = coalesce(var.state_storage_account_name, "sttfstate${random_string.state_suffix[0].result}")
}

resource "azurerm_resource_group" "state" {
  name     = var.state_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "state" {
  name                     = local.state_storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 14
    }

    container_delete_retention_policy {
      days = 14
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "state" {
  name                  = var.state_container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

resource "azurerm_resource_group" "identity" {
  name     = var.identity_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_user_assigned_identity" "github_actions" {
  name                = var.identity_name
  location            = azurerm_resource_group.identity.location
  resource_group_name = azurerm_resource_group.identity.name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "github_environment" {
  for_each = var.github_environments

  name                = "github-${var.github_repository}-${each.value}"
  resource_group_name = azurerm_resource_group.identity.name
  parent_id           = azurerm_user_assigned_identity.github_actions.id

  issuer   = "https://token.actions.githubusercontent.com"
  audience = ["api://AzureADTokenExchange"]
  subject  = "repo:${var.github_organization}/${var.github_repository}:environment:${each.value}"
}

resource "azurerm_role_assignment" "terraform_subscription" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "terraform_state_blob_data_contributor" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}
