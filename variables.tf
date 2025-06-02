variable "api_key" {
  description = "API key for Azure Naming Tool API."
  type        = string
}

variable "api_url" {
  description = "Base URL for Azure Naming Tool API (e.g., https://azurenamingtool-xxxx.azurewebsites.net/)."
  type        = string
}

variable "components" {
  description = "Map of component names and their values."
  type        = map(string)
}

variable "client_id" {
  description = "Azure AD App Registration (client) - client_id"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant_id"
  type        = string
}

variable "client_secret" {
  description = "Azure AD App Registration (client) - client_secret"
  type        = string
  sensitive   = true
}

variable "api_app_id" {
  description = "App Registration ID of the API (Azure Naming Tool)"
  type        = string
}