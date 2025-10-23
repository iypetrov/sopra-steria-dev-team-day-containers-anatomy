locals {
  vpc_cidr = "10.10.0.0/16"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "github_access_token" {
  type      = string
  sensitive = true
}
