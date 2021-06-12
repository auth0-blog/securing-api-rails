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
