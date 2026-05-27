# Part 1: Setup

In this part we will be preparing our azure environment for use with terraform.

Terraform needs some existing resources to be able to run from pipeline. These include:
- Managed identity: identity that can be used by the pipeline .
- Federated credentials: used to authenticate the pipeline as the managed identity, without using long-lived credentials such as client secrets. 
- Role assignments: Giving the managed identity permissions to create and destroy resources in our environment

## Bootstrap

## 1. Open the repo in Codespaces or a Dev Container

The devcontainer installs:

- Terraform CLI
- Azure CLI
- GitHub CLI

## 2. Authenticate locally

```bash
az login
az account set --subscription "<subscription-id>"
```

Confirm the active subscription:

```bash
az account show --query "{name:name, id:id, tenantId:tenantId}" -o table
```

## 3. Configure bootstrap variables

```bash
cp bootstrap/github-oidc/terraform.tfvars.example bootstrap/github-oidc/terraform.tfvars
```

Edit `bootstrap/github-oidc/terraform.tfvars`:

```hcl
subscription_id     = "468514d9-f054-4201-8f24-55d61d90872f"
tenant_id           = "ee1a7779-f164-43b7-a09a-e9343e8e9d91"
location            = "norwayeast"
github_organization = "msilabben"
github_repository   = "cnapp-module-3-infrastructure"
github_environments = ["dev", "prod"]

identity_resource_group_name = "rg-github-oidc"
identity_name                = "id-github-terraform"

state_resource_group_name  = "rg-tfstate"
state_storage_account_name = "sttfstatecnappinfra001"
state_container_name       = "tfstate"
```

## 4. Run the bootstrap Terraform

```bash
cd bootstrap/github-oidc
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Save the outputs:

```bash
terraform output
```

You need these output values:

- `azure_client_id`
- `azure_tenant_id`
- `azure_subscription_id`
- `state_storage_account_name`

## 5. Update the backend files

Replace `REPLACE_WITH_BOOTSTRAP_OUTPUT` in these files with the `state_storage_account_name` output:

- `environments/dev/backend.tf`
- `environments/prod/backend.tf`

Example:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateabc12345"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
```

For local development, Terraform can still use your Azure CLI login. In GitHub Actions, the backend uses OIDC through the workflow environment variables.
