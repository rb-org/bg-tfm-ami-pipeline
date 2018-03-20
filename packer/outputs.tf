output "sg_id" {
  value = "${aws_security_group.sg_pckr.id}"
}

output "pckr_profile_name" {
  value = "${module.pckr_iam_role.instance_profile_name}"
}

output "pckr_role_name" {
  value = "${module.pckr_iam_role.instance_role_name}"
}
