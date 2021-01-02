provider "aws" {
  alias   = "accountb"
  region  = var.region
  profile = "accountb-profile" #profile name of accunt which configured under the .aws/credentials file
}
resource "aws_route53_zone" "test_domaindelegation" {
  name     = var.hostedzonename
  provider = aws.accountb
  tags     = var.tags
}