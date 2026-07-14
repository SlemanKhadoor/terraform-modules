output "repository_arns" {
  description = "ARNs of the repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.arn }
}

output "repository_names" {
  description = "Names of the repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.name }
}

output "repository_urls" {
  description = "URLs of the repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}

output "registry_ids" {
  description = "Registry IDs of the repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.registry_id }
}