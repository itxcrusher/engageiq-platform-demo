terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = var.region
}

# Placeholder: Cognito User Pool, App Runner service, S3 bucket, DynamoDB table
# Replace these stubs with real resources as you iterate.
