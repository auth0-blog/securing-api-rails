# Hello World API: Ruby on Rails Sample

This sample uses [the ruby-jwt library](https://github.com/jwt/ruby-jwt) to implement the following security tasks:

The `add-authorization` branch offers a working API server that exposes a public endpoint along with two protected endpoints. Each endpoint returns a different type of message: public, protected, and admin.

The `GET /api/messages/protected` and `GET /api/messages/admin` endpoints are protected against unauthorized access. Any requests that contain a valid access token in their authorization header can access the protected and admin data.

However, you should require that only access tokens that contain a `read:admin-messages` permission can access the admin data, which is referred to as [Role-Based Access Control (RBAC)](https://auth0.com/docs/authorization/rbac/).

[Check out the `add-rbac` branch]() to see authorization and Role-Based Access Control (RBAC) in action using Auth0.

## Get Started

You need to have `ruby` installed. I recommend using [rbenv](https://github.com/rbenv/rbenv) to manage different versions. You can install this on OS X:

```bash
brew install rbenv
```

If you're in the folder of the project, running `rbenv install` installs the right version of ruby as specified by the [.ruby-version](./.ruby-version). Then, install the dependencies by running `bundle install`.

There's a `go` script that you can use to execute the different tasks.

### Running the application

Use:

```bash
./go run
```

### Executing the unit tests

Use:

```bash
./go test
```

## Quick Auth0 Set Up

The [api](https://auth0.com/docs/api) is provisioned with [Terraform](https://www.terraform.io/) using [Infrastructure as Code](https://infrastructure-as-code.com/).

You need to install `terraform` first. I recommend using [tfenv](https://github.com/tfutils/tfenv):

```bash
brew install tfenv
(cd terraform && tfenv install)
```

### Creating an API

You have to run the Terraform code to provision an API. The targets are part of the `go` script:

```bash
./go plan # See the resources that will be created
./go apply # Provision the API
./go destroy # Destroy the resources
```

You need to configure some variables first. The easiest way is to export them in the console before running the targets above:

```bash
export TF_VAR_audience=targetAudience.auth0.com
export TF_VAR_auth0_domain=yourTenant.eu.auth0.com
export TF_VAR_auth0_client_id=client-id-of-the-management-api
export TF_VAR_auth0_client_secret=secret-of-the-management-api
```

Then you can run `./go apply` and confirm by writing `yes` when asked.

### Connect with Auth0

To ensure that the application can authenticate properly with _Auth0_ when running `./go run`, you need to define two variables:

```bash
export AUTH0_DOMAIN=yourTenant # Align it with TF_VAR_auth0_domain
export AUTH0_AUDIENCE=targetAudience.auth0.com # Align it with TF_VAR_audience
```

## Test the Protected Endpoints

There's an [application](https://auth0.com/docs/applications) for testing purposes, called _jwt-validation-test_. You can get an access token from the Auth0 Dashboard to test making a secure call to your protected API endpoints.

Head back to your Auth0 API page and click on the "Test" tab.

Locate the section called "Sending the token to the API".

Click on the cURL tab of the code box.

Copy the sample cURL command:

```bash
curl --request GET \
  --url http://localhost:6060/api/messages/protected \
  --header 'authorization: Bearer really-long-string-which-is-test-your-access-token'
```

Replace the value of `http://localhost:6060/api/messages/protected` with your protected API endpoint path (you can find all the available API endpoints in the next section) and execute the command. You should receive back a successful response from the server.

You can try out any of our full stack demos to see the client-server Auth0 workflow in action using your preferred front-end and back-end technologies.

## API Endpoints

### 🔓 Get public message

```bash
GET /api/messages/public
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "message": "The API doesn't require an access token to share this message."
}
```

> 🔐 Protected Endpoints: These endpoints require the request to include an access token issued by Auth0 in the authorization header.

### 🔐 Get protected message

```bash
GET /api/messages/protected
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "message": "The API successfully validated your access token."
}
```

### 🔐 Get admin message

> You need to protect this endpoint using Role-Based Access Control (RBAC).

```bash
GET /api/messages/admin
```

#### Response

```bash
Status: 200 OK
```

```json
{
  "message": "The API successfully recognized you as an admin."
}
```

## Error Handling

### 400s errors

#### Response

```bash
Status: Corresponding 400 status code
```

```json
{
  "message": "Message that describes the error that took place."
}
```

### 500s errors

#### Response

```bash
Status: 500 Internal Server Error
```

```json
{
  "message": "Message that describes the error that took place."
}
```
