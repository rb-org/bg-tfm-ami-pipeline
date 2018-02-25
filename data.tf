// Oauth token is stored in SSM Parameters
data "aws_ssm_parameter" "automation_oauth" {
  name = "/github/rb-org/automation/access_token"
}

// Chef SSM Parameters

data "aws_ssm_parameter" "chef_org" {
  name = "/chef/chef_org"
}

data "aws_ssm_parameter" "chef_svr_fqdn" {
  name = "/chef/server/fqdn"
}
