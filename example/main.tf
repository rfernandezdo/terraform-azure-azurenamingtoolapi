module "azurenamingtool" {
  source        = "../"
  api_key       = var.api_key
  api_url       = var.api_url
  client_id     = var.client_id
  tenant_id     = var.tenant_id
  client_secret = var.client_secret
  api_app_id    = var.api_app_id
  resource_type = var.resource_type
  components    = var.components
}

output "generated_name" {
  value = module.azurenamingtool.generated_name
}

