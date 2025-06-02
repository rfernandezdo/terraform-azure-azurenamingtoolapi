# Installation and Configuration Guide

This guide provides step-by-step instructions to set up and configure the Azure Naming Tool API for use with Terraform. It covers prerequisites, setup, and how to securely call the API from your web app running on Azure App Service.

## Prerequisites
- An Azure Naming Tool instance set up and running.
- An API key for the Azure Naming Tool.
- Add app authentication to your Azure App Service running the Azure Naming Tool API.


## Setup

1. **Create an Azure Naming Tool instance**: Follow the [Azure Naming Tool documentation](https://github.com/mspnp/AzureNamingTool/wiki/Run-as-an-Azure-Web-App-Using-GitHub-Action) to set up your instance.
2. **Get your API key**: After setting up the Azure Naming Tool, obtain your API key from the Azure portal or the tool's admin interface.
3. **Configure calling the Azure Naming Tool API**: Follow the steps below to configure your web app and call the API securely.



## Configure calling the Azure Naming Tool API


### 1. Add app authentication to your web app running on Azure App Service

Use this guide to set up your Azure Naming Tool API: [Quickstart: Add app authentication to your web app running on Azure App Service](https://learn.microsoft.com/azure/app-service/scenario-secure-app-authentication-app-service?tabs=workforce-configuration)

As scope configuration, use `api://<API-APP-ID>/.default` where `<API-APP-ID>` is the Application ID of your Azure Naming Tool API app registration.

### 2. Get a Token (with curl)

```bash
curl -X POST "https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=<CLIENT_ID>&scope=api://<API-APP-ID>/.default&client_secret=<CLIENT_SECRET>&grant_type=client_credentials"
```
- The response will include `"access_token": "..."`

---

### 3. Call the API with the Token

```bash
curl -X POST "https://<your-namingtool-app>.azurewebsites.net/api/ResourceNamingRequests/RequestName" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -d '{
    "resourceEnvironment": "prd",
    "resourceInstance": "2",
    "resourceLocation": "eu",
    "resourceProjAppSvc": "spa",
    "resourceType": "redis"
  }'
```

---

## Security Recommendation

**Do not commit your API key or other sensitive information to version control.**

When using this module in CI/CD (e.g., GitHub Actions), store your `api_key`,  as a repository secret (e.g., `AZURE_NAMING_TOOL_API_KEY`). Reference it in your workflow and pass it to Terraform as an environment variable or through your `terraform.tfvars` file.

### Example GitHub Actions usage

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
      - name: Terraform Init & Apply
        env:
          TF_VAR_api_key: ${{ secrets.AZURE_NAMING_TOOL_API_KEY }}
          TF_VAR_api_url: "https://azurenamingtool-xxxx.azurewebsites.net/api/"
          TF_VAR_tenant_id: ${{ secrets.AZURE_TENANT_ID }}
          TF_VAR_client_id: ${{ secrets.AZURE_CLIENT_ID }}
          TF_VAR_client_secret: ${{ secrets.AZURE_CLIENT_SECRET }}
        run: |
          cd example
          terraform init
          terraform apply -auto-approve
```

This ensures your API key is never exposed in your codebase.

## API Documentation

This module is a POC that interacts with the Azure Naming Tool API. For more details on the API endpoints, request and response formats, and error handling, refer to your "https://azurenamingtool-*.azurewebsites.net/swagger/index.html" documentation.