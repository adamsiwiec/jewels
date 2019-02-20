provider "aws" {
  profile = "default" 
  region     = "us-east-1"
}

variable "aws_region" { default = "us-east-1"}
variable "apex_function_api" {}
variable "api_gateway_role" { default = "arn:aws:iam::823387765616:role/jewels" }

resource "aws_api_gateway_rest_api" "JewelsAPI" {
  name = "JewelsAPI"
  description = "provides endpoints for the jewels service"

}

resource "aws_api_gateway_resource" "JewelsResource" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.JewelsAPI.root_resource_id}"
  path_part   = "api"
}

resource "aws_api_gateway_method" "JewelsMe" {
  rest_api_id   = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id   = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method   = "GET"
  authorization = "NONE"


  request_parameters = {
      
      "method.request.header.Access-Control-Allow-Origin" = true
  }
  
}

resource "aws_api_gateway_integration" "JewelsLambdaIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsMe.http_method}"
  integration_http_method = "POST"
  credentials = "${var.api_gateway_role}"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.apex_function_api}/invocations"
  request_templates = {
  "application/json" = <<EOF
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}

EOF
  }
}

resource "aws_api_gateway_integration_response" "JewelsAPI_myEndpoint_post" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsMe.http_method}"
  status_code = "${aws_api_gateway_method_response.JewelsAPI_myEndpoint_post_200.status_code}"
  response_parameters = 
{
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}

}

resource "aws_api_gateway_integration_response" "JewelsAPI_myEndpoint_post_400" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsMe.http_method}"
  status_code = "${aws_api_gateway_method_response.JewelsAPI_myEndpoint_post_400.status_code}"
  selection_pattern = ".*message.*"
  response_templates = {
    "application/json" = <<EOT
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))
{
  "message" : "$errorMessageObj.message"
}
EOT
  }
  response_parameters =
{
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}

}

resource "aws_api_gateway_method_response" "JewelsAPI_myEndpoint_post_200" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsMe.http_method}"
  status_code = "200"
#   response_models = {
#     "application/json" = "Empty"
#   }
  response_parameters =
{
    "method.response.header.Access-Control-Allow-Origin" = true
}
}

resource "aws_api_gateway_method_response" "JewelsAPI_myEndpoint_post_400" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsMe.http_method}"
  status_code = "400"
#   response_models = {
#     "application/json" = "Empty"
#   }
  response_parameters = 
{
    "method.response.header.Access-Control-Allow-Origin" = true
}
}

resource "aws_api_gateway_method" "JewelsOptions" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "JewelsOptionsInt" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsOptions.http_method}"
  type = "MOCK"
  request_templates = {
    "application/json" = <<EOT
{"statusCode": 200}
EOT
  }
}

resource "aws_api_gateway_integration_response" "JewelsOptionsInt200" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsOptions.http_method}"
  status_code = "${aws_api_gateway_method_response.JewelsOptionsRes200.status_code}"
  response_parameters = 
{
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}
  response_templates = {
      "application/json" = <<EOT
{}
EOT
    }
}

resource "aws_api_gateway_method_response" "JewelsOptionsRes200" {
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  resource_id = "${aws_api_gateway_resource.JewelsResource.id}"
  http_method = "${aws_api_gateway_method.JewelsOptions.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters =
{
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
}

}

resource "aws_api_gateway_deployment" "JewelsAPI" {
  depends_on = [
    "aws_api_gateway_integration.JewelsLambdaIntegration",
    "aws_api_gateway_integration_response.JewelsAPI_myEndpoint_post",
    "aws_api_gateway_integration_response.JewelsAPI_myEndpoint_post_400",
    "aws_api_gateway_method_response.JewelsAPI_myEndpoint_post_200",
    "aws_api_gateway_method_response.JewelsAPI_myEndpoint_post_400",
    "aws_api_gateway_integration.JewelsOptionsInt"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.JewelsAPI.id}"
  stage_name = "test"
}