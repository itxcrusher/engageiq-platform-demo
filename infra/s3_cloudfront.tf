#######################
# 1.  S3  + CloudFront#
#######################
resource "aws_s3_bucket" "static_assets" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name        = "engageiq-static-${var.environment}"
    Environment = var.environment
  }
}

# (Website config optional when using OAC, but harmless)
resource "aws_s3_bucket_website_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id
  index_document { suffix = "index.html" }
}

# Block public ACLs (recommended)
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.static_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################
# 2. CloudFront (OAC)  #
########################
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.environment}-oac"
  description                       = "OAC for static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_site" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_id                = "staticS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "staticS3Origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = { Environment = var.environment }
}

########################################
# 3. Bucket policy for CloudFront OAC  #
########################################
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.static_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontRead"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_assets.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static_site.arn
          }
        }
      }
    ]
  })
}

#################################
# 4. Upload index.html on apply #
#################################
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_assets.bucket
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket.static_assets]
}
