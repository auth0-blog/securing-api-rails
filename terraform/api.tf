resource "auth0_client" "jwt-validation-test" {
  name        = "jwt-validation-test"
  description = "JWT Validation (Test) - Terraform generated"
  app_type    = "non_interactive"

  token_endpoint_auth_method = "client_secret_post"
}

resource "auth0_client_grant" "jwt-validation-test" {
  client_id = auth0_client.jwt-validation-test.id
  audience  = auth0_resource_server.jwt-validation.identifier
  scope     = []
}

resource "auth0_resource_server" "jwt-validation" {
  name             = "jwt-validation"
  identifier       = var.audience
  signing_alg      = "RS256"
  enforce_policies = true

  token_lifetime         = 86400
  token_lifetime_for_web = 7200

  skip_consent_for_verifiable_first_party_clients = true
}
