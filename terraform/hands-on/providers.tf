#AWS Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.69.0"
    }
  }
  # This is the version of Terraform we will use
  required_version = ">= 1.9.6"
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}