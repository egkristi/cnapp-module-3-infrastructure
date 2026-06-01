# Part 2: Scan the environment

Your infrastructure has just been built successfully. But that does not mean it is without flaws.
The `.github/workflows/iac-scan.yml` file includes scanning tools to check for flaws in created branches.


## Task 1: Add flaws to a branch

Create a new branch in your fork.

Change the following lines in `/environments/dev/main.tf`:

```resource "azurerm_role_assignment" "aks_new_acr_pull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_cluster.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "deployment_acr_push" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPush"
  principal_id         = module.federated_id_for_deployment.github_actions_push_principal_id
  principal_type       = "ServicePrincipal"
}```

to

`resource "azurerm_role_assignment" "aks_new_acr_pull" {
  scope                = module.container_registry.id
  role_definition_name = "Owner"
  principal_id         = module.aks_cluster.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "deployment_acr_push" {
  scope                = module.container_registry.id
  role_definition_name = "Owner"
  principal_id         = module.federated_id_for_deployment.github_actions_push_principal_id
  principal_type       = "ServicePrincipal"
}`

Commit your changes and push to your fork.
Go to your created pull requests in GitHub and then "Checks". 
Can you find the code scanning results?
How many flaws are there for both tools?
Do you see the change to Owner flaw somewhere?

## Task 2
We have multiple tasks at this point. You are free to choose which to do and in which order.

### Task a: Fix flaws in your infrastructure

Select some of the flaws identified in the previous step and see if you can fix them using terraform.

### Task b: Add a policy

There is currently one policy for Trivy written in rego at `policy/trivy.rego`.
Can you create a new policy for either Checkkov or Trivy to warn for the Owner role previously introduced?

### Task 3

In `iac-scan.yml` remove the following line:
    if: false # Remove this to enable Policy as Code (PaC) with Open Policy Agent
