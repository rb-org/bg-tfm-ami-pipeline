resource "aws_cloudtrail" "track_build_artifacts" {
  name                          = "${var.name_prefix}-build-artifact-uploads"
  s3_bucket_name                = "${var.cloudtrail_logs_id}"
  s3_key_prefix                 = "build-uploads"
  include_global_service_events = false

  tags {
    Name = "${var.name_prefix}-build-artifact-uploads"
  }
}

# 02/18 Looks like there's no way in terraform to create/configure the cloudtrail data event to monitor the s3 bucket 
# manual configuration until this changes

