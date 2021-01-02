# crossaccount-domain-delegation-tf
Terraform on AWS: Multi-Account Domain Delegation Setup
This repo will proivde the guidance to create a Domain Delegation for a parent domain between two AWS Accounts with Terraform

Here is the scenario;

Account A having the domaindelegation.com domain; If there is a requirement to use the domaindelegation.com domain in Account B we can utilize the Domain Delegation Concept.
AWS DOC REFERENCE: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html

We can create a subdomain(test.domaindelegation.com) in Account B and create a record set of subdomain Name Servers under the Parent Domain using with Terraform Scripts.

Account A having parent domain; domaindelegation.com
Account B: Requirement to create the subdomain test.domaindelegation.com

We can use alias, profile in terraform provider block; if there is a reuirement to connect different regions/accounts for aws resource blocks

https://www.terraform.io/docs/configuration/providers.html
You can optionally define multiple configurations for the same provider, and select which one to use on a per-resource or per-module basis. The primary reason for this is to support multiple regions for a cloud platform; other examples include targeting multiple Docker hosts, multiple Consul hosts, etc.

To create multiple configurations for a given provider, include multiple provider blocks with the same provider name. For each additional non-default configuration, use the alias meta-argument to provide an extra name segment. For example:
provider "aws" {
  region  = var.region
  alias   = "accountA"
  profile = "accountA-profile" #profile name of accunt which configured under the .aws/credentials file
}

provider "aws" {
  alias   = "accountB"
  region  = var.region
  profile = "accountB-profile" #profile name of accunt which configured under the .aws/credentials file
}

Selecting Alternate Provider Configurations:
By default, resources use a default provider configuration (one without an alias argument) inferred from the first word of the resource type name.

To use an alternate provider configuration for a resource or data source, set its provider meta-argument to a <PROVIDER NAME>.<ALIAS> reference:

resource "aws_instance" "foo" {

  provider = aws.accountB
  .....
}

resource "aws_instance" "foo" {

  provider = aws.accountA
  ......
 
}