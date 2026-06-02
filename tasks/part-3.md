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


### 3. Update and publish your application images

We must do a change in both the frontend and backend app.

This will cause the pipeline to run which updates the frontend and backend image versions.

Go into your forked module 2 repo open the following files:

- `frontend/src/index.html`
- `backend/app/main.py`

Do a small change in both, like changing what text gets written by each app before committing.

Watch Actions complete. When it has finished, go to pull requests and click on "chore: main" and confirm merge.

Now go to actions again.

Backend-dev and frontend-dev should now be green and be deployed to your Azure Container Registry (ACR). Prod will fail, ignore this for now.

### 4. Pull the current app version to your Kubernetes cluster

Go to the Azure portal. In the search bar, search for the resource group containing your ACR: `rg-<your username>-dev`

In this resource group, you should see your ACR on the format: `<your username>devxxxxxxx`. ACRs must be globally unique across Azure and will therefore have a random string of characters appended to it.

Inside your ACR, click on "Services" and then "Repositories".

Here you should see both a frontend and backend image. What versions are present in the ACR? Is the hash of the `latest` version the same as that of one of the version numbers? 

After identifying the currnet version number for both frontend and backend, go to your forked Module 2 repository under Actions. 

Click on "Deploy to AKS" and then "Run Workflow". Here you should be able to fill in for which enviroment you would like to deploy and which version of both the frontend and backend.

Fill in the current version numbers before running the workflow.

Does the deployment finish successfully?

###. 5 See your deployment

In the Azure portal, search for your resource group containing your Application Gateway for Containers: `rg-<your username>-dev-aks`. Remember that the app gateway functions as an internet based frontend for the apps inside your Kubernetes cluster.

Inside your resource group go into `agfc-<your username>-dev`, Settings, and then Frontends. 

Try visiting your shown FQDN. Does the application work?


## Extra
We have just successfully deployed our app into our own created infrastructure.

But so far everything has been deployed to Dev. 

The Prod environment does not contain any of our created resources just yet. 

Can you replicate the code from environments/dev and into environments/prod to deploy the same infrastructure? What about publishing an app?
