terraform {
  required_version = ">=1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }

  backend "s3" {
    bucket         = "remote-state-123"
    key            = "state"
    region         = "us-east-1"
    dynamodb_table = "RemoteState"
  }
}
