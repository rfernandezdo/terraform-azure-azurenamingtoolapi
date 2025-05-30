data "external" "aad_token" {
  program = [
    "${path.module}/get_token.sh",
    var.tenant_id,
    var.client_id,
    var.api_app_id,
    var.client_secret
  ]
}

