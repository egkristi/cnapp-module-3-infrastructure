## Part 3: Deploy your app

### 1. Create codespace
Create a new codespace in your module 2 fork. 
Sign in to Azure using the steps provided in `part-1.md`


### 2. Add environment variables

Module 2 requires multiple environment variables to be able to deploy the application to the correct infrastructure.
The required variables are outputted by terraform when running the main pipeline on Module 3.
When committing to your Module 3 forked repo, a pipeline is run which performs `terraform apply`. 
In this stage, `terraform output` is run and displayed. 
Go to Actions in Module 3, identify a workflow which has run on `main`.
Go into this workflow and click on `Terraform apply dev`.
This job performs many steps, including `Terraform Apply`.
Scroll to the bottom of this job to see outputted variables. 
Save these variables.

Now go to your forked Module 3 repo and create the Environment variable `dev`. 
Use the outputted variables or identify manually in the Azure portal to fill inn the following Environment variables into `dev`:

- `ACR_NAME`: <???>
- `AGFC_FRONTEND_NAME`: <???>
- `AGFC_NAME`: <???>
- `AKS_CLUSTER`: <???>
- `AZURE_DEPLOY_CLIENT_ID`: <???>
- `AZURE_PUSH_CLIENT_ID`: <???>
- `AZURE_RESOURCE_GROUP`: <???>
- `KEYVAULT_NAME`: <???>
- `KEYVAULT_IDENTITY_CLIENT_ID`: <???>


### 3

We must do a change in both the frontend and backend app.
This will cause the pipeline to run which updates the frontend and backend image versions.
Go into your forked module 2 repo open the following files:
- `frontend/src/index.html`
- `backend/app/main.py`

Do a small change in both, like changing what text gets written by each app.
Do:
```
git add.
git commit -m "fix"
git push
```

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
