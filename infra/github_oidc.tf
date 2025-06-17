# 1. Get account ID
data "aws_caller_identity" "current" {}

# 2. Create GitHub OIDC provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub’s root cert
}

# 3. Trust policy to allow GitHub to assume the role
data "aws_iam_policy_document" "github_oidc_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:itxcrusher/engageiq-platform-demo:ref:refs/heads/main"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# 4. Role to be assumed by GitHub Actions
resource "aws_iam_role" "github_oidc_role" {
  name               = "github-actions-deploy-engageiq"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume.json
}

# 5. Attach policies
resource "aws_iam_role_policy_attachment" "ecr_push_policy" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "app_runner_deploy" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSAppRunnerFullAccess"
}
