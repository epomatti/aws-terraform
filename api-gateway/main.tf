terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = "sa-east-1"
}

resource "aws_apigatewayv2_api" "main" {
  name          = "json-placeholder-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "json_placeholder" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "https://jsonplaceholder.typicode.com/{proxy}"
}

resource "aws_apigatewayv2_route" "all" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.json_placeholder.id}"
}

resource "aws_apigatewayv2_deployment" "todos" {
  api_id      = aws_apigatewayv2_route.all.api_id
  description = "All"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id        = aws_apigatewayv2_api.main.id
  name          = "$default"
  deployment_id = aws_apigatewayv2_deployment.todos.id
  auto_deploy   = true

  default_route_settings {
    throttling_burst_limit = 1
    throttling_rate_limit  = 1
  }

}
