data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "identity" {
  name     = var.identity_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "state" {
  name     = var.state_resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                     = var.state_storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_container" "state" {
  for_each = var.environments

  name                  = each.value.state_container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

resource "azurerm_resource_group" "environment" {
  for_each = var.environments

  name     = each.value.resource_group_name
  location = var.location

  tags = merge(var.tags, {
    environment = each.key
  })
}

resource "azurerm_user_assigned_identity" "plan" {
  for_each = var.environments

  name                = each.value.plan_identity_name
  location            = azurerm_resource_group.identity.location
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_user_assigned_identity" "apply" {
  for_each = var.environments

  name                = each.value.apply_identity_name
  location            = azurerm_resource_group.identity.location
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "dev_plan_pull_request" {
  name                = "github-${var.github_repository}-dev-plan-pr"
  resource_group_name = azurerm_resource_group.identity.name
  parent_id           = azurerm_user_assigned_identity.plan["dev"].id

  audience = ["api://AzureADTokenExchange"]
  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${var.github_organization}/${var.github_repository}:pull_request"
}

resource "azurerm_federated_identity_credential" "apply_environment" {
  for_each = var.environments

  name                = "github-${var.github_repository}-${each.key}-apply"
  resource_group_name = azurerm_resource_group.identity.name
  parent_id           = azurerm_user_assigned_identity.apply[each.key].id

  audience = ["api://AzureADTokenExchange"]
  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${var.github_organization}/${var.github_repository}:environment:${each.key}"
}

resource "azurerm_role_assignment" "plan_reader" {
  for_each = var.environments

  scope                = azurerm_resource_group.environment[each.key].id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.plan[each.key].principal_id
}

resource "azurerm_role_assignment" "plan_state_reader" {
  for_each = var.environments

  scope                = "${azurerm_storage_account.state.id}/blobServices/default/containers/${azurerm_storage_container.state[each.key].name}"
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.plan[each.key].principal_id
}

resource "azurerm_role_assignment" "apply_contributor" {
  for_each = var.environments

  scope                = azurerm_resource_group.environment[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.apply[each.key].principal_id
}

resource "azurerm_role_assignment" "apply_rbac_administrator" {
  for_each = var.environments

  scope                = azurerm_resource_group.environment[each.key].id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azurerm_user_assigned_identity.apply[each.key].principal_id
}

resource "azurerm_role_assignment" "apply_state_owner" {
  for_each = var.environments

  scope                = "${azurerm_storage_account.state.id}/blobServices/default/containers/${azurerm_storage_container.state[each.key].name}"
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.apply[each.key].principal_id
}
