data "azurerm_resource_group" "environment" {
  name = "rg-${var.name_prefix}-dev"
}

data "azurerm_resource_group" "environment_aks" {
  name = "rg-${var.name_prefix}-dev-aks"
}


data "azurerm_kubernetes_cluster" "environment" {
  name                = "aks-${var.name_prefix}-dev"
  resource_group_name = data.azurerm_resource_group.environment_aks.name
}

resource "azurerm_user_assigned_identity" "github_actions" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "github_environment" {
  for_each = toset(var.github_environments)

  name                = "github-${var.github_repository}-${each.key}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.github_actions.id

  audience = ["api://AzureADTokenExchange"]
  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${var.github_organization}/${var.github_repository}:environment:${each.key}"
}

locals {
  role_assignment_scopes = {
    environment     = data.azurerm_resource_group.environment.id
    environment_aks = data.azurerm_resource_group.environment_aks.id
  }
}

resource "azurerm_role_assignment" "terraform_resource_group" {
  for_each = local.role_assignment_scopes

  scope                = each.value
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "aks_cluster_user" {
  scope                = data.azurerm_kubernetes_cluster.environment.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}
