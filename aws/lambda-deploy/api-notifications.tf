resource "aws_api_gateway_rest_api" "notification_rest_api" {
  name = "Notification Api"
  description = "This is used to test lambdafucntion"
}

resource "aws_api_gateway_resource" "NotifcationApi" {
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  parent_id = "${aws_api_gateway_rest_api.notification_rest_api.root_resource_id}"
  path_part = "notifications"
}

resource "aws_api_gateway_method" "CreateNotification" {
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.NotifcationApi.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "NotificationLambdaIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.NotifcationApi.id}"
  http_method = "${aws_api_gateway_method.CreateNotification.http_method}"
  type = "AWS"
  uri = "arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-southeast-2:773592622512:function:${aws_lambda_function.notification_post_function.function_name}/invocations"
  integration_http_method = "${aws_api_gateway_method.CreateNotification.http_method}"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.NotifcationApi.id}"
  http_method = "${aws_api_gateway_method.CreateNotification.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "lambda-notification-post-reponse" {
  depends_on = ["aws_api_gateway_integration.NotificationLambdaIntegration"]
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.NotifcationApi.id}"
  http_method = "${aws_api_gateway_method.CreateNotification.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}
resource "aws_api_gateway_deployment" "lambda-api-deployment" {
  depends_on = ["aws_api_gateway_integration_response.lambda-notification-post-reponse"]
  rest_api_id = "${aws_api_gateway_rest_api.notification_rest_api.id}"
  stage_name = "dev"
}
output "api-path" {
    value = "${aws_api_gateway_resource.NotifcationApi.path_part}"
}
