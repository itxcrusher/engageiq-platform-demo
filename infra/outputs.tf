output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.static_site.domain_name
  description = "URL of the static front-end (CloudFront)"
}

output "cognito_pool_id" {
  value       = aws_cognito_user_pool.pool.id
  description = "Cognito User Pool ID"
}

output "cognito_client_id" {
  value       = aws_cognito_user_pool_client.client.id
  description = "Cognito User Pool Client ID"
}

output "app_runner_service_url" {
  value       = aws_apprunner_service.backend.service_url
  description = "Base URL of the backend API"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.chat_history.name
  description = "Chat history table"
}

output "ecr_repo_uri" {
  value       = aws_ecr_repository.engageiq.repository_url
  description = "ECR Repo URI for pushing the Docker image"
}

output "github_oidc_role_arn" {
  value       = aws_iam_role.github_oidc_role.arn
  description = "OIDC IAM role for GitHub Actions"
}
