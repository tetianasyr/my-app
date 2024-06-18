provider "aws" {
  region = "eu-central-1"
  profile = "tf-profile"
}

terraform {
  required_version = ">=1.8.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.49"
    }
  }
}

