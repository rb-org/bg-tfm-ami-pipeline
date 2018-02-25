// Codebuild Dev Plan & Apply

data "aws_region" "current" {}

resource "aws_codebuild_project" "build_ami_ws" {
  name          = "${var.name_prefix}-build-ami-ws"
  description   = "AMI Creation Pipeline - Web Server"
  build_timeout = "15"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type           = "S3"
    location       = "${var.codebuild_s3_id}"
    packaging      = "ZIP"
    path           = "ami_build_output.zip"
    namespace_type = "BUILD_ID"
    name           = "ami_build_output"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ubuntu-base:14.04"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "BUILD_VPC_ID"
      "value" = "${var.vpc_id}"
    }

    environment_variable {
      "name"  = "BUILD_SUBNET_ID"
      "value" = "${var.subnet_id}"
    }

    environment_variable {
      "name"  = "AWS_REGION"
      "value" = "${data.aws_region.current.name}"
    }

    environment_variable {
      "name"  = "AWS_ACCOUNTS"
      "value" = "${var.acc_id}"
    }

    environment_variable {
      "name"  = "AWS_REGIONS"
      "value" = "${var.copy_to_region}"
    }

    environment_variable {
      "name"  = "SVR_TYPE"
      "value" = "bg-packer"
    }

    environment_variable {
      "name"  = "CHEF_ENV"
      "value" = "${var.dev_wkspc}"
    }

    environment_variable {
      "name"  = "CHEF_ROLE"
      "value" = "bg-web-ws"
    }

    environment_variable {
      "name"  = "CHEF_ORG"
      "value" = "${var.chef_org}"
    }

    environment_variable {
      "name"  = "CHEF_SVR"
      "value" = "${var.chef_svr_fqdn}"
    }

    environment_variable {
      "name"  = "EC2_PROFILE"
      "value" = "${var.ec2_profile}"
    }

    environment_variable {
      "name"  = "PCKR_SG"
      "value" = "${var.pckr_sg}"
    }

    environment_variable {
      "name"  = "BUILD_VER"
      "value" = "1.1.1"
    }
  }

  source {
    type      = "GITHUB"
    buildspec = "buildspec-ami.yml"
    location  = "${var.pckr_source}"

    auth {
      "type" = "OAUTH"

      # "resource" = "${var.oauth_token}"
    }
  }

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-cbd-ami-ws", var.name_prefix))
    )
  }"
}
