// Codebuild

// Lambda function for sending codebuild status via Cloudwatch to Slack
resource "aws_lambda_function" "build_upload_lambda" {
  filename      = "./lambda/release.zip"
  function_name = "${var.name_prefix}-build-upload"

  #role             = "${aws_iam_role.slack_lambda_role.arn}"
  role             = "${module.slack_lambda_role.role_arn}"
  handler          = "src/index.handler"
  source_code_hash = "${base64sha256(file("./lambda/release.zip"))}"
  runtime          = "nodejs6.10"
  timeout          = 10

  environment {
    variables = {
      SLACK_HOOK_URL = "${var.slack_webhook}"
    }
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "build_upload_lambda_perms" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.build_upload_lambda.function_name}"
  principal      = "events.amazonaws.com"
  source_account = "${var.acc_id}"
  source_arn     = "${aws_cloudwatch_event_rule.build_event_rule_upload.arn}"
}
