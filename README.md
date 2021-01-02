# crossaccount-domain-delegation-tf
Terraform on AWS: Multi-Account Domain Delegation Setup
This repo will proivde the guidance to create a Domain Delegation between two AWS Accounts.

Here is the scenario;

Account A having the domaindelegation.com domain; If there is a requirement to use the domaindelegation.com domain in Account B we can utilize the Domain Delegation Concept.
AWS DOC REFERENCE: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html

We can create a subdomain(test.domaindelegation.com) in Account B and create a record set of subdomain Name Servers under the Parent Domain using with Terraform Automation;

