variable "name_prefix" {}
variable "vpc_id" {}
variable "environment" {}

variable "default_tags" {
  type = "map"
}

variable "codebuild_s3_arn" {}
variable "codebuild_s3_id" {}
variable "subnet_id" {}
variable "acc_id" {}
variable "copy_to_region" {}
variable "oauth_token" {}
variable "dev_wkspc" {}
variable "chef_org" {}
variable "chef_svr_fqdn" {}
variable "ec2_profile" {}
variable "pckr_sg" {}
variable "pckr_source" {}
