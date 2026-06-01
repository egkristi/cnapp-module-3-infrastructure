# Part 0: Prerequisites

Make sure you have:
- The Microsoft Authenticator app installed.
- A GitHub account

## Account creation

You will be given a use with access to the lab subscription. This user is on the format:
username: cnappuser<number>@mnelab.onmicrosoft.com
password: mnemonicCNAPPlabb<number>

Your username on the format cnappuser<number> will from now on be referred to as <your username>

Go to portal.azure.com and sign in to your account.
You will be asked to both change password and setup the authenticator app.
Store the password somewhere safe.
Follow the steps provided. 
When you have signed into the account, search for "Subscriptions". 
You should now be able to the see subscription "Sandbox"


## Forking the repos

In this lab you will be building the infrastructure to host an application and install the application on the created infratructure.
For this you will need to fork two repos:
- https://github.com/msilabben/cnapp-module-3-infrastructure
- https://github.com/msilabben/cnapp-module-2-application

When forking these repoes, set the owner to "msilabben" and append your username to the repository name:
cnapp-module-3-infrastructure-<your username>
cnapp-module-2-application-<your username>

Lastly, workflows must be enabled on both workspaces. In your forked repos, go to Actions and click on Enable workflows.

# Part 1: Setup
For the following steps we will be using the forked cnapp-module-3-infrastructure repo unless stated otherwise.
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
az login --use-device-code
```

Confirm the active subscription:

```bash
az account show --query "{name:name, id:id, tenantId:tenantId}" -o table
```
You should see Sandbox.

## 3. Configure bootstrap variables

```bash
cp bootstrap/github-oidc/terraform.tfvars.example bootstrap/github-oidc/terraform.tfvars
```

Edit `bootstrap/github-oidc/terraform.tfvars`:

```hcl
name_prefix   = "<your username>"
location      = "norwayeast"

github_organization = "msilabben"
github_repository   = "<your M3 repository>"

tags = {
  managed_by = "terraform"
  project    = "<your M3 repository>"
}
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

Check the following output:

```bash
terraform output
```
Save the output for later.

You currently need these output values:

- `dev_environment_variables = {AZURE_APPLY_CLIENT_ID}`
- `state_resource_group_name`
- `state_storage_account_name`

## 5. Update the backend files

Replace the values in the following file with those from the terraform output:

- `environments/dev/backend.tf`

Example:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<state_resource_group_name>"
    storage_account_name = "<state_storage_account_name>"
    container_name       = "tfstate-dev"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}
```

For local development, Terraform can still use your Azure CLI login. In GitHub Actions, the backend uses OIDC through the workflow environment variables.

## 6. Create GitHub Environments

In GitHub go to your fork: https://github.com/msilabben/cnapp-module-3-infrastructure-<your username>/settings
Go to settings, Environments, create two Environments:

- `dev`
- `prod`
Environment variables:
AZURE_CLIENT_ID: <value of dev_environment_variables/AZURE_APPLY_CLIENT_ID>
same with prod.

For `prod`, configure required reviewers before deployments are allowed. Add yourself.
Review what settings might be useful to enable/disble as opposed to `dev`.


## 7 Update infrastructure automation value
Open the file `environments/dev/dev.auto.tfvars` and change the following values.
These cannot be empty
key_vault_administrator_principal_ids = [value of <dev_environment_variables/AZURE_APPLY_CLIENT_ID>]
both dev and prod

and
github_repository   = "cnapp-module-2-application-testbruker1"


## 6. 1
Go to actions in your repo, allow workflows


## 7. Add GitHub Environment variables

Add the `azure_client_id` to your GitHub repository "Repositroy Variables":

fetch dev AZURE_PLAN_CLIENT_ID
Go to Settings > Secrets and Variables > actions > Variables > New repository variable

```text
AZURE_CLIENT_ID       = <bootstrap output azure_client_id>
```

## 8

change the following files:

env/dev/dev.auto.tfvars

## 9. format

run terraform fmt --recursive on root

## 10. Push to GitHub

git add .
git commit -m "run bootstrap"
git push

open commits, go to actions, enable

On pull requests, `.github/workflows/terraform-plan.yml` runs plans for `dev` and `prod`.

On push to `main`, `.github/workflows/terraform-apply.yml` applies `dev`.

For `prod`, run the `Terraform apply` workflow manually and select `prod`. The GitHub `prod` Environment should require approval.
