variable "name_prefix" {}
variable "build_artifacts_id" {}
variable "cloudtrail_logs_id" {}
variable "codebuild_prj_arn" {}
variable "ami_codebuild_role_arn" {}

variable "default_tags" {
  type = "map"
}

variable "environment" {}
variable "build_artifacts_arn" {}
variable "slack_webhook" {}
variable "acc_id" {}
