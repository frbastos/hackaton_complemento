resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${local.env}-http-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "processador_integration" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  integration_type   = "HTTP"
  integration_method = "ANY"
  integration_uri    = "${local.processador_loadbalancer_uri}/{proxy}"

  request_parameters = {
    "overwrite:header.X-User-Sub" = "$request.auth.claims.sub"
  }
}

resource "aws_apigatewayv2_route" "processador_route" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.processador_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}

# Stage
resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "prod"
  auto_deploy = true
}
