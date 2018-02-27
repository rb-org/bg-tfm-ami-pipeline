// Codebuild role and policy

resource "aws_iam_role" "invoke_ami_codebuild_role" {
  name = "${var.name_prefix}-invoke-ami-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invoke_ami_codebuild_policy" {
  name = "${var.name_prefix}-invoke-ami-codebuild-policy"
  role = "${aws_iam_role.invoke_ami_codebuild_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:StartBuild"
            ],
            "Resource": [
                "${aws_codebuild_project.build_ami_ws.id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.name_prefix}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.name_prefix}-codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_iam_policy" "ssm_s3_policy" {
  name        = "${var.name_prefix}-ssm-s3-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "ssm:ListCommands",
            "ssm:ListDocumentVersions",
            "ssm:DescribeInstancePatches",
            "ssm:ListInstanceAssociations",
            "ssm:GetParameter",
            "ssm:GetMaintenanceWindowExecutionTaskInvocation",
            "s3:ListObjects",
            "ssm:DescribeAutomationExecutions",
            "ssm:GetMaintenanceWindowTask",
            "ssm:DescribeMaintenanceWindowExecutionTaskInvocations",
            "ssm:DescribeAutomationStepExecutions",
            "ssm:DescribeParameters",
            "ssm:ListResourceDataSync",
            "ssm:ListDocuments",
            "s3:HeadBucket",
            "ssm:GetMaintenanceWindowExecutionTask",
            "ssm:GetMaintenanceWindowExecution",
            "ssm:GetParameters",
            "ssm:DescribeMaintenanceWindows",
            "ssm:DescribeEffectivePatchesForPatchBaseline",
            "ssm:DescribeDocumentPermission",
            "ssm:ListCommandInvocations",
            "ssm:GetAutomationExecution",
            "ssm:DescribePatchGroups",
            "ssm:GetDefaultPatchBaseline",
            "ssm:DescribeDocument",
            "ssm:DescribeMaintenanceWindowTasks",
            "ssm:ListAssociationVersions",
            "ssm:GetPatchBaselineForPatchGroup",
            "ssm:PutConfigurePackageResult",
            "ssm:DescribePatchGroupState",
            "ssm:DescribeMaintenanceWindowExecutions",
            "ssm:GetManifest",
            "ssm:DescribeMaintenanceWindowExecutionTasks",
            "ssm:DescribeInstancePatchStates",
            "ssm:DescribeInstancePatchStatesForPatchGroup",
            "ssm:GetDocument",
            "ssm:GetInventorySchema",
            "ssm:GetParametersByPath",
            "ssm:GetMaintenanceWindow",
            "ssm:DescribeInstanceAssociationsStatus",
            "ssm:GetPatchBaseline",
            "ssm:ListInventoryEntries",
            "ssm:DescribeAssociation",
            "ssm:GetDeployablePatchSnapshotForInstance",
            "ssm:GetParameterHistory",
            "ssm:DescribeMaintenanceWindowTargets",
            "ssm:DescribePatchBaselines",
            "ssm:DescribeEffectiveInstanceAssociations",
            "ssm:GetInventory",
            "ssm:DescribeActivations",
            "ssm:GetCommandInvocation",
            "ssm:DescribeInstanceInformation",
            "s3:ListAllMyBuckets",
            "ssm:ListTagsForResource",
            "ssm:ListAssociations",
            "ssm:DescribeAvailablePatches"
         ],
         "Resource":"*"
      },
      {
         "Effect":"Allow",
         "Action":"s3:*",
         "Resource":[
            "${var.codebuild_s3_arn}",
            "${var.codebuild_s3_arn}/*"
         ]
      }
   ]
}
POLICY
}

resource "aws_iam_policy_attachment" "ssm_s3_policy_attachment" {
  name       = "ssm-s3-policy-attachment"
  policy_arn = "${aws_iam_policy.ssm_s3_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}
/*
// Lambda send to slack

resource "aws_iam_role" "lambda_slack_role" {
  name = "${var.name_prefix}-lambda-to-slack-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_slack_policy" {
  name = "${var.name_prefix}-lambda-slack-policy"
  role = "${aws_iam_role.lambda_slack_role.id}"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "logs:*",
            "sns:*",
            "codepipeline:*"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}
*/