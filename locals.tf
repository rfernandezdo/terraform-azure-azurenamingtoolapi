locals {
  request_body = var.components

  access_token = data.external.aad_token.result.access_token
}
