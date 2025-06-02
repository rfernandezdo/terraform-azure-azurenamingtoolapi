# Azure Naming Tool Terraform Module

This module generates Azure resource names using the Azure Naming Tool API.

## Usage

```hcl
module "azurenamingtool" {
  source           = "rfernandezdo/azurenamingtoolapi/azure"
  api_key          = var.api_key
  tenant_id        = var.tenant_id
  client_id        = var.client_id
  client_secret    = var.client_secret
  api_url          = var.api_url
  components       = var.components
}
```

## Variables
- `api_key`: The API key for Azure Naming Tool, Name Generation API Key.
- `api_url`: The base URL of the Azure Naming Tool API (e.g., [https://azurenamingtool-xxxx.azurewebsites.net/api/](https://azurenamingtool-xxxx.azurewebsites.net/api/)).
- `tenant_id`: The Azure Active Directory tenant ID.
- `client_id`: The Azure Active Directory client ID.
- `client_secret`: The Azure Active Directory client secret.
- `components`: A map of component names and their values (e.g., { ResourceEnvironment = "prd", ResourceInstance = "2", ResourceLocation = "eu", ResourceProjAppSvc = "spa" }).

For more details on the `components` variable, refer to your "https://azurenamingtool-*.azurewebsites.net/swagger/index.html" documentation, review /api/ResourceNamingRequests/RequestName endpoint documentation.

## Outputs
- `generated_name`: The generated resource name.

## Example

You can find a complete example in the `example` directory. It includes a `terraform.auto.tfvars.renameme` file with sample values for the variables.

Rename it to `terraform.auto.tfvars` and fill in your actual values.

Use [test_namingtool_api.sh](test_namingtool_api.sh) to test the API with the values you set in terraform.auto.tfvars.

## Disclaimer
This module is a proof of concept (POC) and is not intended for production use. It is designed to demonstrate how to interact with the Azure Naming Tool API using Terraform. Use it at your own risk, and ensure you understand the implications of using this module in a production environment.

Because the API does not currently support name destruction, the name is created in the first apply, after which it will return the name that was configured from components.

## Installation and Configuration Guide

You can find the installation and configuration guide in the [docs/INSTALLATION.md](docs/INSTALLATION.md) file.