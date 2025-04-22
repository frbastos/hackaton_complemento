resource "aws_cognito_user_pool" "usuarios" {
  name = "usuarios-dev"

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

}

resource "aws_cognito_user_pool_client" "cliente1" {
  name         = "fiap"
  user_pool_id = aws_cognito_user_pool.usuarios.id

  generate_secret = false

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  callback_urls = ["https://example.com/callback"]
  logout_urls   = ["https://example.com/logout"]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "hackaton-fiap"
  user_pool_id = aws_cognito_user_pool.usuarios.id
}

resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  name             = "CognitoJWTAuth"
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.cliente1.id]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.usuarios.id}"
  }
}
