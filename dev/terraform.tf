provider "aws" {
  region = "us-east-1"
  profile = "tf-default"
}

terraform {
  required_version = ">=1.8.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.49"
    }
  }

#   backend "s3" {
#     bucket = "myapppet-terraform-bucket"
#     key    = "state/terraform_state.tfstate"
#     region = "us-east-1"
#   }
}

