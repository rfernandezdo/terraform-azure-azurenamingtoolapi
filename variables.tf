variable "api_key" {
  description = "API key for Azure Naming Tool API."
  type        = string
}

variable "api_url" {
  description = "Base URL for Azure Naming Tool API (e.g., https://azurenamingtool-xxxx.azurewebsites.net/)."
  type        = string
}

variable "resource_type" {
  description = "Azure resource type (e.g., 'redis')."
  type        = string
}

variable "components" {
  description = "Map of component names and their values."
  type        = map(string)
}

variable "access_token" {
  description = "OAuth2 Bearer token for Azure AD authentication."
  type        = string
  default     = null
  sensitive   = true
  /*  validation {
    condition     = can(regex("^[A-Za-z0-9-_.~+/]+=*$", var.access_token))
    error_message = "The access_token must be a valid OAuth2 Bearer token."
  }*/
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

variable "existing_generated_name_id" {
  description = "If provided, use this existing generated name ID for lookup/validation instead of generating a new name."
  type        = string
  default     = null
}
