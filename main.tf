data "http" "name_generation_post" {
  url    = "${var.api_url}/api/ResourceNamingRequests/RequestName"
  method = "POST"
  request_headers = {
    Authorization = "Bearer ${local.access_token}" # Asegúrate que local.access_token está disponible
    APIKey        = var.api_key
    Content-Type  = "application/json"
  }
  request_body = jsonencode(local.request_body) # Asegúrate que local.request_body está disponible
}

