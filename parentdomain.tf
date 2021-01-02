provider "aws" {
  region  = var.region
  alias   = "accounta"
  profile = "accounta-profile" #profile name of accunt which configured under the .aws/credentials file
}

terraform {
  required_version = "> 0.12"
  backend "s3" {
    bucket  = "{BUCKETNAME}"
    key     = "{PATH/terraform.tfstate}"
    region  = "us-east-1"
    encrypt = true
    profile = "accounta-profile"
  }
}

data "aws_route53_zone" "parent_domain" {
  name         = var.hostedzone
  provider     = aws.nonprod
  private_zone = false
}

resource "aws_route53_record" "aws_sub_zone_ns" {
  provider = aws.nonprod
  zone_id  = "${data.aws_route53_zone.parent_domain.zone_id}"
  name     = "${var.namespace}.aws.${var.hostedzone}"
  type     = "NS"
  ttl      = "30"

  records = [
    for awsns in aws_route53_zone.eu_c4454n.name_servers :
    awsns
  ]
}