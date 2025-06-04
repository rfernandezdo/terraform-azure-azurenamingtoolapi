module "azurenamingtool" {
  source        = "../"
  api_key       = var.api_key
  api_url       = var.api_url
  client_id     = var.client_id
  tenant_id     = var.tenant_id
  client_secret = var.client_secret
  api_app_id    = var.api_app_id
  components    = var.components
}

output "generated_name" {
  value = module.azurenamingtool.generated_name
}

output "resource_name_not_generated" {
  value = module.azurenamingtool.resource_name_not_generated
}

output "generated_name_id" {
  value = module.azurenamingtool.generated_name_id
}

resource "azurerm_resource_group" "example" {
  name     = module.azurenamingtool.generated_name
  location = "West Europe"
  tags = {
    environment = "example"
    project     = "azurenamingtool"
  }
  depends_on = [module.azurenamingtool.show_name_generation]
}
