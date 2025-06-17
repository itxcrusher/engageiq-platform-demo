###############################
# 5. App Runner (backend API) #
###############################
resource "aws_apprunner_service" "backend" {
  service_name = var.app_runner_service_name

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
    image_repository {
      image_identifier      = var.image_identifier # ECR URI:tag
      image_repository_type = "ECR"
      image_configuration { port = "8000" }
    }
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }
  tags = { Environment = var.environment }
}
