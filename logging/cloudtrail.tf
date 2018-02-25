resource "aws_cloudtrail" "track_build_artifacts" {
  name                          = "${var.name_prefix}-build-artifact-uploads"
  s3_bucket_name                = "${var.cloudtrail_logs_id}"
  s3_key_prefix                 = "build-uploads"
  include_global_service_events = false

  event_selector {
    read_write_type           = "All"
    include_management_events = false

    data_resource {
      type = "AWS::S3::Object"

      values = [
        "${var.build_artifacts_arn}/",
      ]
    }
  }

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-build-artifact-uploads", var.name_prefix))
    )
  }"
}
