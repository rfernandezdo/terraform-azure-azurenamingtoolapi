locals {
  request_body = merge(var.components, { ResourceType = var.resource_type })

  access_token = data.external.aad_token.result.access_token
}
