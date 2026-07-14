output "endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
}

output "identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.identifier
}