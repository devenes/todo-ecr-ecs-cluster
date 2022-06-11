
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.26.1"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  # If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

provider "github" {
  token = var.github-token
}
