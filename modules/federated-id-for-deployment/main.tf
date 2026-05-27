data "azurerm_subscription" "current" {}

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

resource "azurerm_role_assignment" "terraform_subscription" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}
