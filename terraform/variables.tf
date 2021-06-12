variable "auth0_domain" {
  description = "The auth0 domain"
}

variable "auth0_client_id" {
  description = "Client_id of an API with access to the Auth0 Management API"
}

variable "auth0_client_secret" {
  description = "The secret for the same API"
}

variable "audience" {
  description = "Audience for the API"
}
