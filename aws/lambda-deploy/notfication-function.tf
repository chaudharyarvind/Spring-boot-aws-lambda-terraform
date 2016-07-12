resource "aws_iam_role_policy" "access_notification_table_policy" {
    name = "notification-api-lamda-policy"
    role = "${aws_iam_role.lambda_function_role.id}"
    depends_on = ["aws_dynamodb_table.notification_dynamodb_table"]
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:ap-southeast-2:773592622512:table/${aws_dynamodb_table.notification_dynamodb_table.name}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_function_role" {
  name = "notification-api-lamda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "notification_post_function" {
    filename = "../build/libs/notification-service-lambda-1.0.0.jar"
    function_name = "notificationSpringBoot"
    description = "Lambda function to create a notification."
    depends_on = ["aws_iam_role.lambda_function_role"]
    role = "${aws_iam_role.lambda_function_role.arn}"
    runtime = "java8"
    timeout = "60"
    handler = "com.dius.PostHandler"
    memory_size = 512
    source_code_hash = "${base64sha256(file("../build/libs/notification-service-lambda-1.0.0.jar"))}"
}

resource "aws_lambda_permission" "allow_api_gateway" {
    function_name = "${aws_lambda_function.notification_post_function.function_name}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:ap-southeast-2:773592622512:${aws_api_gateway_rest_api.notification_rest_api.id}/*/${aws_api_gateway_integration.NotificationLambdaIntegration.integration_http_method}${aws_api_gateway_resource.NotifcationApi.path}"
}
