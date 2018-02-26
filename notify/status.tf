// Codebuild

// Lambda function for sending codebuild status via Cloudwatch to Slack
resource "aws_lambda_function" "codebuild_lambda" {
  filename         = "./lambda/slack.js.zip"
  function_name    = "${var.name_prefix}-cdb-status"
  role             = "${aws_iam_role.lambda_slack_role.arn}"
  handler          = "slack.handler"
  source_code_hash = "${base64sha256(file("./lambda/slack.js.zip"))}"
  runtime          = "nodejs6.10"

  environment {
    variables = {
      SLACK_HOOK_URL = "${var.slack_webhook}"
    }
  }
}

resource "aws_lambda_permission" "cdb_allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.codebuild_lambda.function_name}"
  principal      = "events.amazonaws.com"
  source_account = "${var.acc_id}"
  source_arn     = "${aws_cloudwatch_event_rule.build_event_rule.arn}"
}

// Cloudwatch event for Codebuild status 
resource "aws_cloudwatch_event_rule" "build_event_rule" {
  name        = "${var.name_prefix}-cdb-status"
  description = "CodeBuild Build State Change"

  # role_arn    = "${aws_iam_role.cloudwatch_lambda_role.arn}"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "FAILED",
      "IN_PROGRESS",
      "STOPPED",
      "SUCCEEDED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "build_lambda_func" {
  rule      = "${aws_cloudwatch_event_rule.build_event_rule.name}"
  target_id = "${var.name_prefix}-cdb-status"
  arn       = "${aws_lambda_function.codebuild_lambda.arn}"
}