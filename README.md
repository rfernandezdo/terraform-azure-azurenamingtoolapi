# Azure Naming Tool Terraform Module

This module generates Azure resource names using the Azure Naming Tool API.

## Usage

```hcl
module "azurenamingtool" {
  source           = "./azurenamingtool_module"
  api_key          = var.api_key
  api_url          = var.api_url
  resource_type    = var.resource_type
  components       = var.components
}
```

## Variables
- `api_key`: The API key for Azure Naming Tool.
- `api_url`: The base URL of the Azure Naming Tool API (e.g., [https://azurenamingtool-xxxx.azurewebsites.net/api/](https://azurenamingtool-xxxx.azurewebsites.net/api/)).
- `resource_type`: The Azure resource type (e.g., "redis").
- `components`: A map of component names and their values (e.g., { ResourceEnvironment = "prd", ResourceInstance = "2", ResourceLocation = "eu", ResourceProjAppSvc = "spa" }).

## Outputs
- `generated_name`: The generated resource name.

## Example

Create a directory named `example` with the following files:

**example/terraform.tfvars**
```
api_key      = "YOUR_API_KEY_HERE"
api_url      = "https://azurenamingtool-ehgnc8hyhmepguey.spaincentral-01.azurewebsites.net/api/"
resource_type = "redis"
components = {
  ResourceEnvironment = "prd"
  ResourceInstance    = "2"
  ResourceLocation    = "eu"
  ResourceProjAppSvc  = "spa"
}
```

**example/variables.tf**
```
variable "api_key" {
  description = "API key for Azure Naming Tool API."
  type        = string
}

variable "api_url" {
  description = "Base URL for Azure Naming Tool API."
  type        = string
}

variable "resource_type" {
  description = "Azure resource type."
  type        = string
}

variable "components" {
  description = "Map of component names and their values."
  type        = map(string)
}
```

**example/main.tf**
```
module "azurenamingtool" {
  source        = "../azurenamingtool_module"
  api_key       = var.api_key
  api_url       = var.api_url
  resource_type = var.resource_type
  components    = var.components
}

output "generated_name" {
  value = module.azurenamingtool.generated_name
}
```

To test the module:
1. Replace `YOUR_API_KEY_HERE` in `terraform.tfvars` with your actual API key.
2. Run `terraform init` and `terraform apply` inside the `example` directory.
3. The generated Azure resource name will be shown in the output.

## Security Recommendation

**Do not commit your API key to source control.**

When using this module in CI/CD (e.g., GitHub Actions), store your `api_key` as a repository secret (e.g., `AZURE_NAMING_TOOL_API_KEY`). Reference it in your workflow and pass it to Terraform as an environment variable or through your `terraform.tfvars` file.

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
        run: |
          cd example
          terraform init
          terraform apply -auto-approve
```

This ensures your API key is never exposed in your codebase.

## Testing with curl

You can test the Azure Naming Tool API directly with curl before using the Terraform module. Make sure to use camelCase for all JSON keys and a valid resourceType from your Naming Tool configuration.

**Example curl command:**

```bash
curl -X POST "https://azurenamingtool-ehgnc8hyhmepguey.spaincentral-01.azurewebsites.net/api/ResourceNamingRequests/RequestName" \
  -H "Content-Type: application/json" \
  -H "APIKey: YOUR_API_KEY_HERE" \
  -d '{
    "resourceEnvironment": "prd",
    "resourceInstance": "2",
    "resourceLocation": "eu",
    "resourceProjAppSvc": "spa",
    "resourceType": "redis"
  }'
```

- Replace `YOUR_API_KEY_HERE` with your actual API key from the Azure Naming Tool admin.
- Replace the values and keys as needed for your configuration.
- If you get a 400 error, check that `resourceType` is a valid value in your Naming Tool instance and all keys are camelCase.

## Terraform configuration notes

- In your `example/terraform.tfvars`, use camelCase for all keys in the `components` map:

```hcl
components = {
  resourceEnvironment = "prd"
  resourceInstance    = "2"
  resourceLocation    = "eu"
  resourceProjAppSvc  = "spa"
}
```

- The module will automatically add `resourceType` in camelCase.
- Make sure your `api_url` ends with `/api/`.
- If your API is protected by Azure AD (OAuth 2.0), you must obtain a bearer token and use it in the `Authorization` header instead of `APIKey`.

## Usage with Mastercard/restapi provider

This module now uses the [Mastercard/restapi](https://registry.terraform.io/providers/Mastercard/restapi/latest/docs) provider for better support of custom headers and OAuth2 authentication.

### Required variables
- `api_key`: The API key for Azure Naming Tool.
- `access_token`: The OAuth2 Bearer token (see below for how to obtain).
- `api_url`: The base URL of the Azure Naming Tool API (e.g., https://azurenamingtool-xxxx.azurewebsites.net/api/).
- `resource_type`: The Azure resource type (e.g., "redis").
- `components`: A map of component names and their values (camelCase, e.g., `{ resourceEnvironment = "prd", resourceInstance = "2", resourceLocation = "eu", resourceProjAppSvc = "spa" }`).

### Example terraform.tfvars
```hcl
api_key      = "YOUR_API_KEY_HERE"
access_token = "YOUR_BEARER_TOKEN_HERE"
api_url      = "https://azurenamingtool-xxxx.azurewebsites.net/api/"
resource_type = "redis"
components = {
  resourceEnvironment = "prd"
  resourceInstance    = "2"
  resourceLocation    = "eu"
  resourceProjAppSvc  = "spa"
}
```

### Example main.tf
```hcl
module "azurenamingtool" {
  source        = "../azurenamingtool_module"
  api_key       = var.api_key
  access_token  = var.access_token
  api_url       = var.api_url
  resource_type = var.resource_type
  components    = var.components
}

output "generated_name" {
  value = module.azurenamingtool.generated_name
}
```

### How to obtain the Bearer token
See the [Azure AD client credentials flow](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow) or use the following curl command:

```bash
curl -X POST "https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=<CLIENT_ID>&scope=api://<API-APP-ID>/.default&client_secret=<CLIENT_SECRET>&grant_type=client_credentials"
```

## Cómo obtener el token OAuth2 directamente con Terraform

Puedes obtener el token de Azure AD directamente en Terraform usando el data source `azuread_token` del proveedor [AzureAD](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/token) o el data source `http`/`external` para una llamada manual. Aquí tienes un ejemplo usando el proveedor AzureAD:

### 1. Añade el proveedor AzureAD en tu `versions.tf`:

```hcl
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.47.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.19.2"
    }
  }
}
```

### 2. Usa el data source para obtener el token:

```hcl
data "azuread_token" "namingtool" {
  client_id     = var.client_id
  tenant_id     = var.tenant_id
  client_secret = var.client_secret
  scopes        = ["api://${var.api_app_id}/.default"]
}
```

### 3. Pásalo al módulo:

```hcl
module "azurenamingtool" {
  source        = "../azurenamingtool_module"
  api_key       = var.api_key
  access_token  = data.azuread_token.namingtool.access_token
  api_url       = var.api_url
  resource_type = var.resource_type
  components    = var.components
}
```

### 4. Añade las variables necesarias en tu `variables.tf`:

```hcl
variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "api_app_id" {}
```

---

**Ventajas:**
- No necesitas scripts externos ni curl.
- El token se gestiona automáticamente en cada `terraform apply`.

**Notas:**
- El proveedor AzureAD debe estar autenticado (puedes usar variables de entorno o Azure CLI login).
- Si tu API requiere un scope diferente, ajústalo en el parámetro `scopes`.

## Troubleshooting

- If you get a 401 error, check your API key or authentication method.
- If you get a 400 error with `ResourceType value is invalid.`, check the allowed values in your Naming Tool configuration and use camelCase for all keys.
- Use the `api_response_body` and `api_status_code` outputs from the module for debugging.

For more details on Azure AD authentication, see the [official Microsoft guide](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow) or the [Postman example](https://dev.to/425show/calling-an-azure-ad-secured-api-with-postman-22co).