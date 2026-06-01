## Part 3: Deploy your app

### 1. Create codespace
Create a new codespace in your module 2 fork. 
Sign in to Azure using the steps provided in `part-1.md`


### 2. Add environment variables

Module 2 requires multiple environment variables to be able to deploy the application to the correct infrastructure.
When committing to your Module 3 forked repo, a pipeline is run which performs `terraform apply`. 
In this stage, terraform output is run and displayed. 
Go to Actions in Module 3, identify a workflow which has run on `main`.
Go into this workflow and click on `Terraform apply dev`.
This job performs many steps, including `Terraform Apply`.
Scroll to the bottom of this job to see outputted variables. 


Use these or identity manually in the Azure portal to fill inn the following Environment variables in dev


Create  a new Environment variable called `dev`.

Using the output generated from `terraform output` in the previous task or the Azure portal, you need to create and fill in the following variables:

- `ACR_NAME`: <???>
- `AGFC_FRONTEND_NAME`: <???>
- `AGFC_NAME`: <???>
- `AKS_CLUSTER`: <???>
- `AZURE_DEPLOY_CLIENT_ID`: <???>
- `AZURE_PUSH_CLIENT_ID`: <???>
- `AZURE_RESOURCE_GROUP`: <???>
- `KEYVAULT_NAME`: <???>
- `KEYVAULT_IDENTITY_CLIENT_ID`: <???>



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
