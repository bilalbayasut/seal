# This block stores terraform settings
terraform {
  # We can define providers such as AWS, Azure, etc.
  # in this block along with their version and
  # where terraform should download them from.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }
  # This is the version of Terraform we will use
  required_version = ">= 1.9.6"
}

# These are provider-specific settings
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "PathToTerraformCertInstance"
  }
}