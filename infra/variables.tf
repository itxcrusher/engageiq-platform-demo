variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name"
  default     = "demo"
}

variable "s3_bucket_name" {
  description = "Globally-unique S3 bucket name"
  default     = "engageiq-demo-bucket" # Must be globally unique
}

variable "cognito_domain_prefix" {
  description = "Unique prefix for Cognito domain"
  default     = "engageiq-demo-domain"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  default     = "engageiq-demo-chat"
}

variable "app_runner_service_name" {
  description = "App Runner service name"
  default     = "engageiq-demo-backend"
}

variable "image_identifier" {
  description = "ECR image URI (e.g. acct.dkr.ecr.eu-west-1.amazonaws.com/repo:tag)"
  default     = "969812667920.dkr.ecr.eu-west-1.amazonaws.com/engageiq-demo:latest"
}
