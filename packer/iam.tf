// EC2 Role
module "pckr_iam_role" {
  source = "git@github.com:rb-org/terraform-aws-iam-misc//default_ec2_role"

  name                  = "${var.name_prefix}-${terraform.workspace}-ec2-role-pckr"
  principal_identifiers = ["ec2.amazonaws.com"]
  principal_type        = "Service"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ]
}
