resource "aws_s3_bucket" "frontend" {
  bucket = "${var.name}-frontend"
  
  tags = merge({
    Name = "${var.name}-frontend"
  }, var.tags)
}

resource "aws_s3_bucket_versioning" "frontend" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.frontend.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  count  = var.enable_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  # For CloudFront-only access, keep these as true
  block_public_acls       = true
  block_public_policy     = true  # Allow CloudFront policy
  ignore_public_acls      = true
  restrict_public_buckets = true  # Allow CloudFront policy
}

resource "aws_s3_bucket_policy" "frontend" {
  count  = var.cloudfront_distribution_arn != null ? 1 : 0
  bucket = aws_s3_bucket.frontend.id
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}