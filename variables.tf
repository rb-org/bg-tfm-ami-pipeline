variable "name_prefix" {
  default = "bg" # This should be shortened to exol when moving to a live
}

variable "region" {
  default = "eu-west-1"
}

variable "acc_id" {}

variable "environment" {}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = "map"

  default = {
    Terraform          = "true"
    GitHubRepo         = "bg-tfm-ami-pipeline"
    GitHubOrganization = "rb-org"
  }
}

variable "key_name" {
  default = "bg-pckr-euw"
}

variable "pckr_source" {
  default = "https://github.com/rb-org/bg-tfm-ec2.git"
}

variable "dev_wkspc" {
  default = "d202"
}
