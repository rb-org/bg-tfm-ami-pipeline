terraform {
  #  required_version = "0.11.2"

  backend "s3" {
    bucket  = "bg-tfm-state"
    region  = "eu-west-1"
    key     = "bg-ami-pipeline.tfstate"
    encrypt = "true"
  }
}

// Remote State from base/networking plan
data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    region = "${var.region}"
    bucket = "bg-tfm-state"
    key    = "env:/${var.dev_wkspc}/bg-base.tfstate"
  }
}

// Remote state from common plan
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    region = "${var.region}"
    bucket = "bg-tfm-state"

    #key    = "env:/xxx/bg-common.tfstate"
    key = "bg-common.tfstate"
  }
}

// Remote state from ec2 plan
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config {
    region = "${var.region}"
    bucket = "bg-tfm-state"
    key    = "env:/${var.dev_wkspc}/bg-ec2.tfstate"
  }
}
