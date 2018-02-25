provider "aws" {
  region              = "${var.region}"
  allowed_account_ids = ["${var.acc_id}"]
}

module "packer" {
  source = "./packer"

  name_prefix  = "${var.name_prefix}"
  vpc_id       = "${data.terraform_remote_state.network.vpc_id}"
  environment  = "${var.environment}"
  default_tags = "${var.default_tags}"
}

module "codebuild" {
  source = "./codebuild"

  name_prefix      = "${var.name_prefix}"
  acc_id           = "${var.acc_id}"
  environment      = "${var.environment}"
  oauth_token      = "${data.aws_ssm_parameter.automation_oauth.value}"
  vpc_id           = "${data.terraform_remote_state.network.vpc_id}"
  subnet_id        = "${data.terraform_remote_state.network.public_subnet_ids[0]}"
  copy_to_region   = "eu-west-1"                                                     # Multiple regions - "eu-central-1,eu-west-1"
  ec2_profile      = "${data.terraform_remote_state.ec2.default_profile_name}"
  pckr_sg          = "${module.packer.sg_id}"
  pckr_source      = "${var.pckr_source}"
  codebuild_s3_arn = "${data.terraform_remote_state.common.codebuild_artifacts_arn}"
  codebuild_s3_id  = "${data.terraform_remote_state.common.codebuild_artifacts_id}"
  dev_wkspc        = "${var.dev_wkspc}"
  chef_org         = "${data.aws_ssm_parameter.chef_org.value}"
  chef_svr_fqdn    = "${data.aws_ssm_parameter.chef_svr_fqdn.value}"
  default_tags     = "${var.default_tags}"
}

module "logging" {
  source = "./logging"

  name_prefix            = "${var.name_prefix}"
  environment            = "${var.environment}"
  build_artifacts_id     = "${data.terraform_remote_state.common.build_artifacts_id}"
  build_artifacts_arn    = "${data.terraform_remote_state.common.build_artifacts_arn}"
  cloudtrail_logs_id     = "${data.terraform_remote_state.common.cloudtrail_logs_id}"
  ami_codebuild_role_arn = "${module.codebuild.ami_codebuild_role_arn}"
  codebuild_prj_arn      = "${module.codebuild.ami_ws_cbld_proj_id}"
  default_tags           = "${var.default_tags}"
}
