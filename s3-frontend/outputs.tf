output "bucket_name" {
  description = "Name of the S3 frontend bucket"
  value       = aws_s3_bucket.frontend.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 frontend bucket"
  value       = aws_s3_bucket.frontend.arn
}

output "bucket_id" {
  description = "ID of the S3 frontend bucket"
  value       = aws_s3_bucket.frontend.id
}

output "website_endpoint" {
  description = "S3 website endpoint (only available when website hosting is enabled)"
  value       = var.enable_website_hosting ? aws_s3_bucket_website_configuration.frontend[0].website_endpoint : null
}

output "website_domain" {
  description = "S3 website domain (only available when website hosting is enabled)"
  value       = var.enable_website_hosting ? aws_s3_bucket_website_configuration.frontend[0].website_domain : null
}

output "cloudfront_policy_applied" {
  description = "Whether CloudFront-only access policy is applied"
  value       = var.cloudfront_distribution_arn != null
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.frontend.bucket_domain_name
}