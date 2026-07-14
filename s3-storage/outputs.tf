output "bucket_name" {
  description = "Name of the S3 storage bucket"
  value       = aws_s3_bucket.storage.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 storage bucket"
  value       = aws_s3_bucket.storage.arn
}

output "bucket_id" {
  description = "ID of the S3 storage bucket"
  value       = aws_s3_bucket.storage.id
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.storage.bucket_domain_name
}

output "bucket_region" {
  description = "S3 bucket region"
  value       = aws_s3_bucket.storage.region
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = var.enable_versioning
}

output "encryption_enabled" {
  description = "Whether encryption is enabled"
  value       = var.enable_encryption
}