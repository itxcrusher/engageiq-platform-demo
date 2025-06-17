# ── Account ID (used only for reference) ────────────────────────────────────────
data "aws_caller_identity" "current" {}

# ── 1. OIDC provider for GitHub Actions ────────────────────────────────────────
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # LE ISRG Root X1
}

# ── 2. Trust-policy document for the role GitHub will assume ───────────────────
data "aws_iam_policy_document" "github_oidc_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # Match repo and branch exactly (replace user/org & branch if different)
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:itxcrusher/engageiq-platform-demo:ref:refs/heads/main"
      ]
    }

    # GitHub always sets aud=sts.amazonaws.com
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# ── 3. IAM role GitHub will assume ─────────────────────────────────────────────
resource "aws_iam_role" "github_oidc_role" {
  name               = "github-actions-deploy-engageiq"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume.json
}

# ── 4. Permissions the workflow actually needs ─────────────────────────────────
# Push & pull from ECR
resource "aws_iam_role_policy_attachment" "ecr_poweruser" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# Deploy to App Runner
resource "aws_iam_role_policy_attachment" "apprunner_full" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSAppRunnerFullAccess"
}
