output "ami_ws_cbld_proj_id" {
  value = "${aws_codebuild_project.build_ami_ws.id}"
}

output "ami_codebuild_role_arn" {
  value = "${aws_iam_role.invoke_ami_codebuild_role.arn}"
}
