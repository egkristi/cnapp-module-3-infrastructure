# Part 0: Prerequisites

Make sure you have:

- The Microsoft Authenticator app installed.
- A GitHub account. You will be invited to join the organization.

## Account creation

You will be given a user with access to the lab subscription. This user follows the format:

```text
username: cnappuser<number>@mnelab.onmicrosoft.com
password: mnemonicCNAPPlabb<number>
```

Your username in the format `cnappuser<number>` will from now on be referred to as `<your username>`.

Go to `portal.azure.com` and sign in to your account.

You will be asked to both change your password and set up the authenticator app. Store the password somewhere safe and follow the steps provided.

When you have signed in to the account, search for `Subscriptions`.

You should now be able to see the subscription `Sandbox`.

## Forking the repositories

In this lab, you will build the infrastructure needed to host an application. You will also install the application on the created infrastructure.

For this, you need to fork two repositories:

- https://github.com/msilabben/cnapp-module-3-infrastructure
- https://github.com/msilabben/cnapp-module-2-application

When forking these repositories, set the owner to `msilabben` and append your username to the repository name:

```text
cnapp-module-3-infrastructure-<your username>
cnapp-module-2-application-<your username>
```

Lastly, workflows must be enabled on both workspaces. In your forked repositories, go to `Actions` and click `Enable workflows`.

# Part 1: Setup

For the following steps, use the forked `cnapp-module-3-infrastructure` repository unless stated otherwise.

In this part, you will prepare the Azure environment for use with Terraform.

Terraform needs some existing resources before it can run from the pipeline. These include:

- Managed identity: identity that can be used by the pipeline.
- Federated credentials: used to authenticate the pipeline as the managed identity without using long-lived credentials such as client secrets.
- Role assignments: gives the managed identity permissions to create and destroy resources in the environment.

## Bootstrap

### 1. Open the repository in Codespaces or a Dev Container

The dev container installs the required tools:

- Terraform CLI
- Azure CLI
- GitHub CLI

### 2. Authenticate locally

Run the following command:

```bash
az login --use-device-code
```

Confirm the active subscription:

```bash
az account show --query "{name:name, id:id, tenantId:tenantId}" -o table
```

You should see `Sandbox`.

### 3. Configure bootstrap variables

Copy the example Terraform variables file:

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

### 4. Run the bootstrap Terraform

Navigate to the bootstrap folder and run Terraform:

```bash
cd bootstrap/github-oidc
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Check the Terraform output:

```bash
terraform output
```

Save the output for later.

You currently need these output values:

- `dev_environment_variables = {AZURE_APPLY_CLIENT_ID}`
- `state_resource_group_name`
- `state_storage_account_name`

### 5. Update the backend files

Replace the values in the following file with the values from the Terraform output:

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

### 6. Create GitHub Environments

In GitHub, go to your fork:

```text
https://github.com/msilabben/cnapp-module-3-infrastructure-<your username>/settings
```

Go to `Settings`, then `Environments`, and create two environments:

- `dev`
- `prod`

Add the following environment variable to both environments:

```text
AZURE_CLIENT_ID: <value of dev_environment_variables/AZURE_APPLY_CLIENT_ID>
```

For `prod`, configure required reviewers before deployments are allowed. Add yourself as a reviewer.

Keep the rest of the settings as they are, but review which settings might be useful to enable or disable compared to `dev`.

### 7. Update infrastructure automation values

Open the file:

```text
environments/dev/dev.auto.tfvars
```

Values in this file cannot be empty because they are required by Terraform.

Change the following values to the values found in the Terraform output:

```hcl
key_vault_administrator_principal_ids = "<dev_environment_variables/AZURE_APPLY_CLIENT_ID>"
github_repository   = "<your forked module 2 github repo>"
```

### 8. Format the Terraform files

Fix formatting by running the following command in the workspace folder:

```bash
terraform fmt --recursive
```

### 9. Push to GitHub

Run the following commands:

```bash
cd /workspaces/cnapp-module-3-infrastructure-<your username>/
git add .
git commit -m "Added variables. Build infrastructure"
git push
```

Follow the given URL and watch the deployment in `Actions` in your forked repository.

On pull requests, `.github/workflows/terraform-plan.yml` runs plans for `dev` and `prod`.

On push to `main`, `.github/workflows/terraform-apply.yml` applies `dev`.

> **Important:** Do not manually deploy to `prod` yet.
>
> The `prod` environment has not been configured in this lab step. Do not run the `Terraform apply` workflow manually for `prod` unless you are explicitly instructed to do so later.
>
> For now, only verify that the `dev` deployment runs successfully.
