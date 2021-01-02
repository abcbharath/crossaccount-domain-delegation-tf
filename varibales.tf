variable "region" {
  description = "Region in which to deploy the API"
  default     = "us-east-1"
}
variable "description" {
  default     = "Creating a HostedZone in ACCOUNTB "
  description = "Creating a HostedZone in ACCOUNTB "
}
variable "hostedzonename" {
  description = "HostedZone Name for ACCOUNTB Region"
  default     = "test.domaindelegation.com"
}
variable "environment" {
  default = "test"
}
variable "namespace" {
  default = "test"
}
variable "hostedzone" {
  default = "domaindelegation.com"
}
variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default = {
    Environment      = "TEST"
    Description      = "Domain Delegation between accounts"
  }
}