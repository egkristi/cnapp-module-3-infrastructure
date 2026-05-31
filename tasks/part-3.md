## Part 0: build your app

Go to your module 2 fork, create a new codespace.

You need the following environment variables.

They are outputs from the initial terraform apply run in part 1.
Go to:
https://github.com/msilabben/cnapp-module-3-infrastructure-testbruker1/actions
identify a workflow running on main.
Go into Terraform apply dev > Terraform apply, scroll to the bottom.
You should see outputs on the following format:

Now go to environment variables in your forked m2. 
You will need to use the outputs to set the following environment variables:

Outputs:
acr_id = "/subscriptions/468514d9-f054-4201-8f24-55d61d90872f/resourceGroups/rg-testbruker1-dev/providers/Microsoft.ContainerRegistry/registries/testbruker1deviumrxacr"
acr_login_server = "testbruker1deviumrxacr.azurecr.io"
acr_name = "testbruker1deviumrxacr"
aks_cluster_id = "/subscriptions/468514d9-f054-4201-8f24-55d61d90872f/resourceGroups/rg-testbruker1-dev-aks/providers/Microsoft.ContainerService/managedClusters/aks-testbruker1-dev"
aks_cluster_name = "aks-testbruker1-dev"
alb_identity_client_id = "fd096649-4da7-498a-8763-552fdf817dc3"
alb_identity_principal_id = "56970399-29b2-48b3-a2a4-743d6b68aa0e"
github_deploy_client_id = "cad6384b-6724-44f7-b869-64e5783d50eb"
github_push_client_id = "4955c9fe-dd3b-4194-9952-969a3d202d4a"
key_vault_name = "kv-testbruker1-dev"
key_vault_uri = "https://kv-testbruker1-dev.vault.azure.net/"
new_acr_id = "/subscriptions/468514d9-f054-4201-8f24-55d61d90872f/resourceGroups/rg-testbruker1-dev/providers/Microsoft.ContainerRegistry/registries/testbruker1deviumrxacr"
new_acr_login_server = "testbruker1deviumrxacr.azurecr.io"
new_acr_name = "testbruker1deviumrxacr"

ACR_NAME
AGFC_FRONTEND_NAME (legge til som output kode/hente fra portalen)
AGFC_NAME
AKS_CLUSTER
AZURE_DEPLOY_CLIENT_ID (github push)
AZURE_PUSH_CLIENT_ID (github deploy)
AZURE_RESOURCE_GROUP
IMAGE_NAME_BACKEND
IMAGE_NAME_FRONTEND
ALB_CONTROLLER_ID

AZURE_SUBSCRIPTION_ID: 468514d9-f054-4201-8f24-55d61d90872f

AZURE_TENANT_ID: ee1a7779-f164-43b7-a09a-e9343e8e9d91


next

We must trigger a change in both the frontend and backend app. 
So identity both and add some arbitrary text.
For example ...

git add.
git commit -m "fix"
(this commit must include a "fix:" in it)
git push
watch actions complete, when done go to pull requests and click on chore main and confirm merge
now go to actions again.

backend-dev and frontend-dev should now work. 
Prod will fail, ignore this for now.

Confirm the images were pushed by going to your container registry in azure and see the current version of both frontend and backend

Here you should see the current backend and frontend version.
no v1.0.0 but 0.0.0
Run workflow



next go to actions in m2, deploy to ASK, run workflow, and fill in the current versions



extra:
prod is way behind and unfinished, oh no!
use the code from environments dev to fix environments prod
