# Part 0: Account creationg

You will be given a user on the format:
username: cnappuser<number>@mnelab.onmicrosoft.com
password: mnemonicCNAPPlabb<number>

## Login
Make sure to have the Microsoft Authenticator app installed.

Go to portal.azure.com and sign in to your account.
You will be asked to both change password and setup the authenticator app
Follow the steps provided. 
When you have signed into the account, search for "Subscriptions". 
You should now be able to the see subscription "Sandbox"


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
github_repository   = "cnapp-module-3-infrastructure-<TODO>"
github_environments = ["dev", "prod"]

identity_resource_group_name = "rg-github-oidc-<TODO>"
identity_name                = "id-github-terraform-<TODO>"

state_resource_group_name  = "rg-tfstate-<TODO>"
state_storage_account_name = "st-tfstate-<TODO>"
state_container_name       = "tfstate-<TODO>"
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

- `AZURE_APPLY_CLIENT_ID`
- `state_storage_account_name`

## 5. Update the backend files

Replace `REPLACE_WITH_BOOTSTRAP_OUTPUT` in these files with the `state_storage_account_name` output:

- `environments/dev/backend.tf`
- `environments/prod/backend.tf`

Example:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-<TODO>"
    storage_account_name = "st-tfstate-<TODO>"
    container_name       = "tfstate-<TODO>"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
```

For local development, Terraform can still use your Azure CLI login. In GitHub Actions, the backend uses OIDC through the workflow environment variables.

## 6. Create GitHub Environments

In GitHub, create two Environments:

- `dev`
- `prod`

For `prod`, configure required reviewers before deployments are allowed.

## 7. Add GitHub Environment variables

Add the `azure_client_id` to your GitHub repository "Repositroy Variables":

Go to Settings > Secrets and Variables > actions > Variables > New repository variable

```text
AZURE_CLIENT_ID       = <bootstrap output azure_client_id>
```

## 8. Configure local tfvars

```bash
cd ../..
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
cp environments/prod/terraform.tfvars.example environments/prod/terraform.tfvars
```

Edit both files and set your actual subscription ID and resource group names.

## 9. Initialize and test locally

```bash
./scripts/tf.sh fmt
./scripts/tf.sh init dev
./scripts/tf.sh validate dev
./scripts/tf.sh plan dev
```

Prod:

```bash
./scripts/tf.sh init prod
./scripts/tf.sh validate prod
./scripts/tf.sh plan prod
```

## 10. Push to GitHub

On pull requests, `.github/workflows/terraform-plan.yml` runs plans for `dev` and `prod`.

On push to `main`, `.github/workflows/terraform-apply.yml` applies `dev`.

For `prod`, run the `Terraform apply` workflow manually and select `prod`. The GitHub `prod` Environment should require approval.
