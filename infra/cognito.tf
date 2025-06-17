################
# 2. Cognito   #
################
resource "aws_cognito_user_pool" "pool" {
  name                = "engageiq-${var.environment}-pool"
  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "engageiq-${var.environment}-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret                      = false
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["https://${aws_cloudfront_distribution.static_site.domain_name}/callback"]
  logout_urls                          = ["https://${aws_cloudfront_distribution.static_site.domain_name}/logout"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.cognito_domain_prefix # <--  must be globally unique
  user_pool_id = aws_cognito_user_pool.pool.id
}