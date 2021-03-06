# bg-tfm-ami-pipeline

|Branch|Build Status|
|---|:---:|
|master |[![CircleCI](https://circleci.com/gh/rb-org/bg-tfm-ami-pipeline.svg?style=svg&circle-token=bfb2de2463a04c1ecd3ed9a96ea690f0c8ba8cec)](https://circleci.com/gh/rb-org/bg-tfm-ami-pipeline)

Codebuild and packer resources for AMI Pipeline

## Terraform workspaces

* xxx

## Project Repos

| Purpose | Repo | Branches | Tfm Workspaces |
|---|:---:|:---:|:---:|
| Common Resources | https://github.com/rb-org/bg-tfm-common | master | xxx|
| Base networking | https://github.com/rb-org/bg-tfm-prd-base | master, uat, dev | p200, t201, d202 |
| EC2 Instances | https://github.com/rb-org/bg-tfm-prd-ec2 | master, uat, dev | p200, t201, d202 |
| AMI Build pipeline | https://github.com/rb-org/bg-tfm-ami-pipeline | master | xxx|

These branch names are used in the CircleCI config.yml.

## Notes

For local builds a "secret.tfvars" file is used. Contains the acc_id variable:

    acc_id = "1234567890"

Should be populated with the AWS account id that will be hosting the resources.

The scripts expect the "deployable" code zip file to be named "Build_Release_20180225.01.zip" where 20180225 is the date and 01 is the index.

## Setup

CircleCI is used to test and run the Terraform plans.

Each repo needs a CircleCI project with Github user account that has sufficient rights to the repository.

All CircleCI builds are configured to run only on creation of a PR (Build Settings\Adcanced Settings)

An IAM user account with Admin privileges is required by CircleCI (this is created by the bg-tfm-common plan)

Not all repos require branches. For those that do, the should be named as above.

## Lambda function

There's a great Lambda function to send all sorts of events to Slack on [github](https://github.com/arabold/aws-to-slack)

The cloudformation has been reworked into Terraform but the lamdba code is unchanged from the source.