resource "auth0_role" "admin" {
  name = "jwt-validation - Editor"

  permissions {
    name                       = "read:admin-messages"
    resource_server_identifier = auth0_resource_server.jwt-validation.identifier
  }
}

resource "auth0_rule" "jwt-validation-assign-roles" {
  name = "jwt-validation-assign-permissions"
  script = templatefile("${path.module}/assign-roles.js", {
    audience : var.audience
  })

  enabled = true
}

resource "auth0_connection" "user-database" {
  name     = "Username-Password-Authentication"
  strategy = "auth0"

  options {
    password_policy = "none"
  }

  enabled_clients = [
    auth0_client.jwt-validation-test-roles.id
  ]

  lifecycle {
    ignore_changes = [
      enabled_clients
    ]
  }
}

# This part needs to be commented out after giving our Terraform Application permissions over the Username-Password-Authentication
resource "auth0_user" "user" {
  connection_name = "Username-Password-Authentication"
  user_id         = "admin"
  email           = "admin@admin.com"
  password        = "admin"
  roles           = [auth0_role.admin.id]

  depends_on = [auth0_connection.user-database]
}

resource "auth0_client" "jwt-validation-test-roles" {
  name        = "jwt-validation-test-roles"
  description = "JWT Validation (Test for Roles) - Terraform generated"
  app_type    = "spa"

  oidc_conformant = true

  grant_types = [
    "http://auth0.com/oauth/grant-type/password-realm",
  ]
}

output "client_id" {
  value = auth0_client.jwt-validation-test-roles.client_id
}

output "client_secret" {
  value = auth0_client.jwt-validation-test-roles.client_secret
}
