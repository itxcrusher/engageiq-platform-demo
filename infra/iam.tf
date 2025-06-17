############################################
# 4. IAM role for App Runner (ECR + Dynamo)
############################################
data "aws_iam_policy_document" "app_runner_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com", "tasks.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_runner_role" {
  name               = "engageiq-${var.environment}-apprunner-role"
  assume_role_policy = data.aws_iam_policy_document.app_runner_assume.json
}

data "aws_iam_policy_document" "app_runner_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["dynamodb:*"]
    resources = [aws_dynamodb_table.chat_history.arn]
  }
}

resource "aws_iam_role_policy" "app_runner_policy" {
  role   = aws_iam_role.app_runner_role.id
  policy = data.aws_iam_policy_document.app_runner_policy.json
}