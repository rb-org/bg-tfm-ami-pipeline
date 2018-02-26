resource "aws_cloudwatch_event_target" "build_upload_sns" {
  #target_id = ""
  rule = "${aws_cloudwatch_event_rule.build_upload_event.id}"
  arn  = "${aws_sns_topic.notify_build_uploads.arn}"

  input_transformer {
    input_paths = {
      key = "$.detail.requestParameters.key"
    }

    input_template = <<TEMPLATE
    {
        "Build artifact" <key> "has been uploaded. Kicking off packer to build a new AMI"
    }
    TEMPLATE
  }
}

resource "aws_cloudwatch_event_target" "trigger_codebuild" {
  #target_id = ""
  rule     = "${aws_cloudwatch_event_rule.build_upload_event.id}"
  arn      = "${var.codebuild_prj_arn}"
  role_arn = "${var.ami_codebuild_role_arn}"

  input_transformer {
    input_paths = {
      key = "$.detail.requestParameters.key"
    }

    input_template = <<TEMPLATE
    {
      "environmentVariablesOverride": [ 
          { 
            "name": "BUILD_VER",
            "value": <key>
          }
      ]
    }
    TEMPLATE
  }
}

resource "aws_cloudwatch_event_rule" "build_upload_event" {
  name        = "${var.name_prefix}-build-upload-events"
  description = "Capture all build upload events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${var.build_artifacts_id}"
      ]
    }
  }
}
PATTERN
}

resource "aws_sns_topic" "notify_build_uploads" {
  name = "${var.name_prefix}-build-upload-notify"
}
